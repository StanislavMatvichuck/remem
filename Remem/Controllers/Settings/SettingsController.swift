//
//  ControllerSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsController: UIViewController {
    // MARK: I18n
    static let title = NSLocalizedString("button.settings", comment: "Settings screen title")

    // MARK: - View lifecycle
    fileprivate let viewRoot = SettingsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = Self.title
        setupEventsHandlers()
    }
}

// MARK: - Private
extension SettingsController {
    private func setupEventsHandlers() {
//        viewRoot.onboardingButton.addGestureRecognizer(
//            UITapGestureRecognizer(target: self, action: #selector(handlePress)))
        viewRoot.remindersButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePress)))
    }
}

// MARK: - User input
extension SettingsController {
    @objc func handlePress(_ sender: UITapGestureRecognizer) {
        switch sender.view {
//        case viewRoot.onboardingButton:
//            guard let main = parent?.presentingViewController as? EntriesListController else { return }
//            dismiss(animated: true) { main.startOnboarding() }
        case viewRoot.remindersButton:
            let controller = RemindersController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            fatalError("unhandled button press")
        }
    }
}
