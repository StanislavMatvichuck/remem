//
//  GoalsInputController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputController: UIViewController {
    // MARK: - Properties
    let event: Event

    private let editUseCase: EventEditUseCaseInput
    private let viewRoot = GoalsInputView()
    private var viewModel: GoalsInputViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    // MARK: - Init
    init(_ event: Event, editUseCase: EventEditUseCaseInput) {
        self.event = event
        self.editUseCase = editUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewModel = GoalsInputViewModel(model: event)
        configureEventHandlers()
        configureNavBar()
        configurePickerDefaultValue()
    }

    private func configureNavBar() {
        title = "Daily goal"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onPressCancelGoal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onPressSaveGoal))
    }
}

// MARK: - Events handling
extension GoalsInputController {
    private func configureEventHandlers() {
        viewRoot.picker.delegate = self
    }

    @objc private func onPressSaveGoal(sender: UIBarButtonItem) {
        print("saved")
        dismiss(animated: true)
    }

    @objc private func onPressCancelGoal(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - Picker delegate
extension GoalsInputController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.textAlignment = .center
        label.text = "\(row)"

        return label
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        let todayWeekDay = Goal.WeekDay.make(.now)
        let todayPickerIndex = componentForWeekDay(weekDay: todayWeekDay)
        let daysDifference = todayPickerIndex - component

        editUseCase.addGoal(to: event, at: .now.days(ago: daysDifference), amount: row)
    }

    private func componentForWeekDay(weekDay: Goal.WeekDay) -> Int {
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

    private func configurePickerDefaultValue() {
        for weekday in Goal.WeekDay.allCases {
            let pickerComponent = componentForWeekDay(weekDay: weekday)
            guard let goalAmount = event.goals(at: weekday).last?.amount else { return }
            viewRoot.picker.selectRow(goalAmount, inComponent: pickerComponent, animated: false)
        }
    }
}
