//
//  ControllerSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class SettingsController: UIViewController {
    // MARK: - Properties
    let service = LocalNotificationsService()
    lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Init
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    fileprivate let viewRoot = SettingsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = "Settings"
        setupEventsHandlers()
        service.delegate = self
        viewRoot.reminderInput.timeInput.inputView = picker
        service.requestPendingNotifications()
    }
}

// MARK: - Private
extension SettingsController {
    private func resetReminderInput() {
        viewRoot.endEditing(true)
        viewRoot.reminderInput.timeInput.text = ""
        viewRoot.reminderInput.titleInput.text = ""
    }

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

        picker.addTarget(self, action: #selector(handlePicker), for: .valueChanged)
    }

    private func show(notifications: [UNNotificationRequest]) {
        let container = viewRoot.remindersStack

        for view in container.arrangedSubviews { view.removeFromSuperview() }

        for notification in notifications {
            guard
                let trigger = notification.trigger as? UNCalendarNotificationTrigger,
                let date = Calendar.current.date(from: trigger.dateComponents)
            else { continue }

            let view = ReminderInputView()
            view.titleInput.text = notification.content.title
            view.timeInput.text = formatter.string(from: date)
            view.titleInput.isEnabled = false
            view.timeInput.isEnabled = false

            container.addArrangedSubview(view)
        }
    }
}

// MARK: - User input
extension SettingsController {
    @objc func handlePressOnboarding() {
        guard let main = presentingViewController as? EntriesListController else { return }
        dismiss(animated: true) { main.startOnboarding() }
    }

    @objc func handlePressCancel() { resetReminderInput() }
    @objc func handleTitleSubmit() { viewRoot.reminderInput.timeInput.becomeFirstResponder() }
    @objc func handleTimeSubmit() {
        let text = viewRoot.reminderInput.titleInput.text!
        let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
        service.addNotification(text: text,
                                hours: components.hour!,
                                minutes: components.minute!,
                                seconds: 0,
                                repeats: true)
        service.requestPendingNotifications()
        resetReminderInput()
    }

    @objc func handlePicker(_ sender: UIDatePicker) {
        viewRoot.reminderInput.timeInput.text = formatter.string(from: picker.date)
    }
}

// MARK: - LocalNotificationsServiceDelegate
extension SettingsController: LocalNotificationsServiceDelegate {
    func authorizationRequest(result: Bool) {}
    func notificationsRequest(result: [UNNotificationRequest]) { show(notifications: result) }
}
