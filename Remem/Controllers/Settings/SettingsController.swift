//
//  ControllerSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsController: UIViewController {
    // MARK: - Init
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    fileprivate let viewRoot = SettingsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = "Settings"
        setupEventsHandlers()
    }
}

// MARK: - User input
extension SettingsController {
    private func setupEventsHandlers() {
        viewRoot.onboardingButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePressOnboarding)))

        viewRoot.reminderInput.timeCancel.target = self
        viewRoot.reminderInput.timeCancel.action = #selector(handlePressCancel)
        viewRoot.reminderInput.titleCancel.target = self
        viewRoot.reminderInput.titleCancel.action = #selector(handlePressCancel)

        viewRoot.reminderInput.titleSubmit.target = self
        viewRoot.reminderInput.titleSubmit.action = #selector(handleTitleSubmit)
        viewRoot.reminderInput.timeSubmit.target = self
        viewRoot.reminderInput.timeSubmit.action = #selector(handleTimeSubmit)
    }

    @objc func handlePressOnboarding() {
        guard let main = presentingViewController as? EntriesListController else { return }
        dismiss(animated: true) { main.startOnboarding() }
    }

    @objc func handlePressCancel() { viewRoot.endEditing(true) }
    @objc func handleTitleSubmit() { viewRoot.reminderInput.timeInput.becomeFirstResponder() }

    @objc func handleTimeSubmit() {
        viewRoot.endEditing(true)
        print("initiate authorization request")
    }
}
