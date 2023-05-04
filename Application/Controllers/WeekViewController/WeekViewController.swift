//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

protocol WeekViewModelFactoring { func makeWeekViewModel() -> WeekViewModel }

final class WeekViewController: UIViewController {
    let presenter: WeekToDayDetailsPresenter
    let factory: WeekViewModelFactoring
    let viewRoot: WeekView

    var viewModel: WeekViewModel { didSet { viewRoot.configure(viewModel) }}

    init(_ factory: WeekViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeWeekViewModel()
        self.viewRoot = WeekView()
        self.presenter = WeekToDayDetailsPresenter()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        viewRoot.goal.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewRoot.scrollToCurrentWeek(viewModel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private
    private func scheduleGoalUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateGoal()
        }
    }

    private func updateGoal() {
        guard let text = viewRoot.goal.text else { return }
        viewModel.goalChangeHander(Int(text) ?? 0, .now)
    }

    private func configureCollection() {
        viewRoot.collection.dataSource = self
        viewRoot.collection.delegate = self
    }

    private func configureAnimator() {
        let yOffset = viewRoot.convert(viewRoot.accessory.frame, to: nil).minY - .buttonMargin / 2
        presenter.presentationAnimator.originHeight = yOffset
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WeekViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.timeline.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.reuseIdentifier, for: indexPath) as? WeekCell else { fatalError("cell type") }

        cell.viewModel = viewModel.timeline[indexPath.row]

        if presenter.animatedCellIndex == indexPath { presenter.dismissAnimator.prepareForAnimation(cell) }

        return cell
    }

    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configureAnimator()
        presenter.animatedCellIndex = indexPath
        viewModel.timeline[indexPath.row]?.select()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewRoot.configureSummary(viewModel)
    }
}

// MARK: - UITextFieldDelegate
extension WeekViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        scheduleGoalUpdate()
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.count <= 4
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewRoot.removePlaceholder()
        viewRoot.resizeGoalInputAndRedrawAccessory()
        viewRoot.moveSelectionToEnd()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewRoot.installPlaceholder()
        viewRoot.resizeGoalInputAndRedrawAccessory()
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension WeekViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? { presenter.presentationAnimator }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? { presenter.dismissAnimator }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? { presenter.dismissTransition }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        DayDetailsPresentationController(
            week: self,
            day: presented as! DayDetailsViewController
        )
    }
}
