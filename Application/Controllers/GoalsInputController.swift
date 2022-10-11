//
//  GoalsInputController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import Domain
import UIKit

class GoalsInputController: UIViewController {
    // MARK: - Properties
    private let viewRoot: GoalsInputView
    private let viewModel: GoalsInputViewModeling
    // MARK: - Init
    init(viewRoot: GoalsInputView, viewModel: GoalsInputViewModeling) {
        self.viewRoot = viewRoot
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureEventHandlers()
        configureNavBar()
        configurePickerDefaultValue()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancel()
    }

    private func configureEventHandlers() {
        viewRoot.picker.delegate = self
    }

    @objc private func onPressSaveGoal(sender: UIBarButtonItem) { viewModel.submit() }
    @objc private func onPressCancelGoal(sender: UIBarButtonItem) { viewModel.cancel() }

    private func configureNavBar() {
        title = String(localizationId: "goalsInput.title")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(localizationId: "button.cancel"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onPressCancelGoal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(localizationId: "button.save"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onPressSaveGoal))
    }

    private func configurePickerDefaultValue() {
        for weekday in WeekDay.allCases {
            let pickerComponent = componentForWeekDay(weekDay: weekday)
            let goalAmount = viewModel.amount(forWeekDay: weekday)
            viewRoot.picker.selectRow(goalAmount, inComponent: pickerComponent, animated: false)
        }
    }
}

// MARK: - Picker delegate
extension GoalsInputController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView
    {
        return viewRoot.makePickerLabel(forRow: row)
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        let todayWeekDay = WeekDay.make(.now)
        let todayPickerIndex = componentForWeekDay(weekDay: todayWeekDay)
        let daysDifference = todayPickerIndex - component
        let date = Date.now.days(ago: daysDifference)
        viewModel.select(newAmount: row, date: date)
    }

    private func componentForWeekDay(weekDay: WeekDay) -> Int {
        switch weekDay {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }
}

// MARK: - GoalsInputViewModelDelegate
extension GoalsInputController: GoalsInputViewModelDelegate {}

extension GoalsInputController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle
    { return .none }
}
