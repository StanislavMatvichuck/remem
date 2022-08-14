//
//  GoalsInputController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputController: UIViewController {
    // MARK: - Properties
    private let viewRoot = GoalsInputView()
    private var viewModel: GoalsInputViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    let event: Event

    // MARK: - Init
    init(_ event: Event) {
        self.event = event
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
        viewModel.isSubmitEnabled = row.isMultiple(of: 2)
    }
}
