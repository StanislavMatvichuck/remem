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

    var scrollHappened = false
    var viewModel: WeekViewModel {
        didSet {
            viewRoot.collection.reloadData()
            updateSummary()
        }
    }

    init(_ factory: WeekViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeWeekViewModel()
        self.viewRoot = WeekView()
        self.presenter = WeekToDayDetailsPresenter()

        super.init(nibName: nil, bundle: nil)

        configureCollection()
        viewRoot.goal.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureCollection() {
        viewRoot.collection.dataSource = self
        viewRoot.collection.delegate = self
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { super.viewDidLoad() }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToCurrentWeek()
    }

    // TODO: add accessory view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func updateSummary() {
        let index = weekIndexForCurrentScrollPosition()

        guard let page = viewModel.pages[index] else { return }

        viewRoot.summary.text = page.sum
        viewRoot.progress.text = page.progress
        viewRoot.goal.text = page.goal

        viewRoot.progress.isHidden = page.progress == nil

        if page.goal == nil {
            viewRoot.installPlaceholder()
        } else {
            viewRoot.removePlaceholder()
        }

        let opacity: Float = page.goalEditable ? 1.0 : 0.2
        viewRoot.goal.layer.opacity = opacity
        viewRoot.goal.isUserInteractionEnabled = page.goalEditable

        viewRoot.resizeGoalInputAndRedrawAccessory()
    }

    // MARK: - Private
    private func weekIndexForCurrentScrollPosition() -> Int {
        let collectionWidth = viewRoot.collection.bounds.width
        let offset = viewRoot.collection.contentOffset.x
        guard offset != 0 else { return 0 }
        return Int(offset / collectionWidth)
    }

    private func scrollToCurrentWeek() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }

    private func setInitialScrollPosition() {
        viewRoot.collection.layoutIfNeeded()
        viewRoot.collection.scrollToItem(
            at: IndexPath(row: viewModel.scrollToIndex, section: 0),
            at: .left,
            animated: false
        )

        updateSummary()
    }

    private func scheduleGoalUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateGoal()
        }
    }

    private func updateGoal() {
        guard let text = viewRoot.goal.text else { return }
        viewModel.goalChangeHander(Int(text) ?? 0, .now)
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
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        let cellYOffset = viewRoot.convert(viewRoot.accessory.frame, to: nil).minY - .buttonMargin / 2
//        let cellYOffset = cell.convert(cell.frame, to: nil).minY

        presenter.presentationAnimator.originHeight = cellYOffset
        presenter.animatedCellIndex = indexPath

        viewModel.timeline[indexPath.row]?.select()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSummary()
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
