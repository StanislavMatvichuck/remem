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

    private func makeWeekIndexForCurrentPosition() -> Int {
        let offset = viewRoot.collection.contentOffset.x

        guard offset != 0 else { return 0 }

        let collectionWidth = viewRoot.collection.bounds.width
        return Int(offset / collectionWidth)
    }

    func updateSummary() {
        let summaryValue = String(viewModel.summaryTimeline[makeWeekIndexForCurrentPosition()] ?? 0)
        viewRoot.summary.text = summaryValue
    }
}

// MARK: - UITextFieldDelegate
extension WeekViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        updateViewAccessory(textField: textField)
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        return prospectiveText.count <= 4
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        updateViewAccessory(textField: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        installDefaultPlaceholder(textField: textField)
        updateViewAccessory(textField: textField)
    }

    private func updateViewAccessory(textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            textField.invalidateIntrinsicContentSize()
            self.viewRoot.setNeedsDisplay()
            self.viewRoot.accessory.setNeedsDisplay()
        }
    }

    private func installDefaultPlaceholder(textField: UITextField) {
        if textField.text == "" {
            textField.attributedPlaceholder = WeekView.goalPlaceholder
        }
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
