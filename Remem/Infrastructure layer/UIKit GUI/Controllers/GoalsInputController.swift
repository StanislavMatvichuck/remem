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
        setupEventHandlers()
    }
}

// MARK: - Events handling
extension GoalsInputController {
    private func setupEventHandlers() {
        viewRoot.enabled.addTarget(self, action: #selector(handleGoalSwitch), for: .valueChanged)
        viewRoot.picker.delegate = self
    }

    @objc private
    func handleGoalSwitch() {
        viewModel.isEnabled.toggle()
    }
}

// MARK: - Picker delegate
extension GoalsInputController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? { return "\(row)" }

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
}
