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
        title = "Daily goal"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewModel = GoalsInputViewModel(model: event)
        setupEventHandlers()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupAppearance()
        super.viewWillAppear(animated)
    }
}

// MARK: - Events handling
extension GoalsInputController {
    private func setupEventHandlers() {
        viewRoot.picker.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onPressCancelGoal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onPressSaveGoal))
    }

    @objc private func onPressSaveGoal(sender: UIBarButtonItem) {
        print("saved")
        dismiss(animated: true)
    }

    @objc private func onPressCancelGoal(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - Private
extension GoalsInputController {
    private func setupAppearance() {
        let cancelAppearance = UIBarButtonItemAppearance(style: .plain)
        cancelAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.font]

        let doneAppearance = UIBarButtonItemAppearance(style: .done)
        doneAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold,
                                          NSAttributedString.Key.foregroundColor: UIHelper.itemFont]
        appearance.backButtonAppearance = cancelAppearance
        appearance.doneButtonAppearance = doneAppearance

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
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
}
