//
//  RemindersController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 22.04.2022.
//

import UIKit

class RemindersController: UITableViewController {
    // MARK: - I18n
    static let title = NSLocalizedString("label.remindersTitle", comment: "Reminders screen title")
    static let addReminder = NSLocalizedString("label.addReminder", comment: "Reminders screen first section title")
    static let existingReminders = NSLocalizedString("label.existingReminders", comment: "Reminders screen second section title")

    // MARK: - Properties
    let service = LocalNotificationsService()
    var reminders: [UNNotificationRequest]?
    lazy var reminderInput = ReminderInput()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Self.title

        setupTableView()
        setupEventHandlers()

        service.delegate = self
        service.requestPendingNotifications()

        view.backgroundColor = UIColor.secondarySystemBackground
    }
}

// MARK: - UITableViewDataSource
extension RemindersController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        reminders?.count ?? 0 > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? Self.addReminder : Self.existingReminders
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : reminders?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.contentView.addSubview(reminderInput)
            cell.backgroundColor = UIColor.clear
            NSLayoutConstraint.activate([
                reminderInput.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                reminderInput.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                reminderInput.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor),
                reminderInput.widthAnchor.constraint(equalTo: cell.contentView.readableContentGuide.widthAnchor)
            ])
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.reuseIdentifier, for: indexPath) as! ReminderCell
        if
            let reminder = reminders?[indexPath.row],
            let trigger = reminder.trigger as? UNCalendarNotificationTrigger,
            let date = Calendar.current.date(from: trigger.dateComponents)
        {
            cell.textLabel!.text = reminder.content.title
            cell.detailTextLabel!.text = ReminderInput.formatter.string(from: date)
        }
        cell.heightAnchor.constraint(equalToConstant: 64).isActive = true
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RemindersController {
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            guard
                let reminders = reminders,
                let reminderToDelete = self.reminders?.remove(at: indexPath.row)
            else { return }
            service.removePendingNotifications(reminderToDelete.identifier)
            if reminders.count == 1 {
                tableView.deleteSections([1], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section != 0
    }
}

// MARK: - Internal
extension RemindersController {
    private func setupTableView() {
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = .sm
    }

    private func setupEventHandlers() {
        reminderInput.addTarget(self, action: #selector(handleReminderSubmit), for: .editingDidEnd)
    }
}

// MARK: - User input
extension RemindersController {
    @objc func handleReminderSubmit() {
        guard
            let title = reminderInput.value.title,
            let hour = reminderInput.value.hour,
            let minute = reminderInput.value.minute
        else { return }

        service.addNotification(text: title,
                                hours: hour,
                                minutes: minute,
                                seconds: 0,
                                repeats: true)

        service.requestPendingNotifications()
    }
}

// MARK: - LocalNotificationsServiceDelegate
extension RemindersController: LocalNotificationsServiceDelegate {
    func authorizationRequest(result: Bool) {}
    func notificationsRequest(result: [UNNotificationRequest]) {
        reminders = result
        tableView.reloadData()
    }
}
