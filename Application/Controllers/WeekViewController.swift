//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

final class WeekViewController: UIViewController {
    let factory: WeekViewModelFactoring
    let viewRoot: WeekView

    var viewModel: WeekViewModel { didSet { viewRoot.configure(viewModel) }}

    init(_ factory: WeekViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeWeekViewModel(visibleDayIndex: nil)
        self.viewRoot = WeekView(viewModel)
        viewRoot.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        viewRoot.goal.goal.delegate = self
        viewRoot.configure(viewModel)
        configureGoalAccessory()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Events handling
    private func configureGoalAccessory() {
        let accessory = viewRoot.goal.accessory
        viewRoot.goal.goal.inputAccessoryView = accessory
        accessory.done.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleDone)
        ))
        accessory.plus.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        accessory.minus.addTarget(self, action: #selector(handleMinus), for: .touchUpInside)
    }

    @objc private func handleDone() {
        viewRoot.endEditing(true)
    }

    @objc private func handlePlus() {
        let parsedAmount = textInputParsedAmount()
        let increasedAmount = parsedAmount + 1
        let increasedAmountString = String(increasedAmount)
        updateGoalFieldWith(amount: increasedAmountString)
    }

    @objc private func handleMinus() {
        let parsedAmount = textInputParsedAmount()
        let decreasedAmount = parsedAmount - 1

        guard decreasedAmount >= 1 else { return }

        let decreasedAmountString = String(decreasedAmount)
        updateGoalFieldWith(amount: decreasedAmountString)
    }

    private func textInputParsedAmount() -> Int { Int(viewRoot.goal.goal.text ?? "") ?? 0 }
    private func updateGoalFieldWith(amount: String) {
        let input = viewRoot.goal.goal
        input.text = amount
        _ = input.delegate?.textField?(
            input,
            shouldChangeCharactersIn: NSRange(),
            replacementString: amount
        )
    }

    // MARK: - Private
    private func scheduleGoalUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateGoal()
        }
    }

    private func updateGoal() {
        guard let text = viewRoot.goal.goal.text else { return }
        viewModel.goalChangeHandler(Int(text) ?? 0)
    }

    private func configureCollection() {
        viewRoot.collection.dataSource = viewRoot
        viewRoot.collection.delegate = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeekViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        viewModel.weekCellFactory.makeViewModel(
            indexPath: indexPath,
            cellPresentationAnimationBlock: DayDetailsAnimationsHelper.makeCellPresentationSliding(
                animatedView: cell,
                heightTo: viewRoot.dayCellVerticalDistanceToBottom
            ),
            cellDismissAnimationBlock: DayDetailsAnimationsHelper.makeCellDismissal(
                animatedView: cell,
                heightTo: viewRoot.dayCellDefaultFrameY
            )
        ).tapHandler()
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionWidth = scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let newTimelineIndex = Int(offset / collectionWidth) * 7
        viewModel = factory.makeWeekViewModel(visibleDayIndex: newTimelineIndex)
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
        viewRoot.goal.removePlaceholder()
        viewRoot.resizeGoalInputAndRedrawAccessory()
        viewRoot.goal.moveSelectionToEnd()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewRoot.goal.installPlaceholder()
        viewRoot.resizeGoalInputAndRedrawAccessory()
    }
}
