//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import IosUseCases
import UIKit

class DayViewController: UIViewController {
    // MARK: - Properties
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    lazy var textField: UITextField? = nil {
        didSet {
            textField?.inputView = picker
            textField?.font = UIHelper.fontBold
            textField?.textColor = UIHelper.itemFont
            textField?.textAlignment = .center
        }
    }

    let useCase: EventEditUseCasing
    let viewRoot: DayDetailsView
    let day: DayComponents
    var event: Event
    var viewModel: DayViewModel

    // MARK: - Init
    init(
        day: DayComponents,
        event: Event,
        useCase: EventEditUseCasing
    ) {
        self.useCase = useCase
        self.event = event
        self.day = day
        self.viewRoot = DayDetailsView()
        self.viewModel = DayViewModel(day: day, event: event)
        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureNavBar()
        configureTableView()
        configurePicker()
    }

    private func configurePicker() {
        picker.date = day.date
        picker.addTarget(self, action: #selector(handleTimeChange), for: .valueChanged)
    }

    private func configureTableView() {
        viewRoot.happenings.dataSource = self
        viewRoot.happenings.delegate = self
    }

    private func configureNavBar() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: String(localizationId: "button.create"),
            style: .plain,
            target: self,
            action: #selector(handleAdd)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: String(localizationId: "button.edit"),
            style: .plain,
            target: self,
            action: #selector(handleEdit)
        )
    }

    private func makeTimeSelectionAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: String(localizationId: "button.create"),
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(
            title: String(localizationId: "button.cancel"),
            style: .cancel,
            handler: nil
        )
        let submit = UIAlertAction(
            title: String(localizationId: "button.create"),
            style: .default,
            handler: handleTimeSelectionSubmit
        )

        alert.addTextField { field in self.textField = field }
        alert.addAction(cancel)
        alert.addAction(submit)

        return alert
    }

    private func updateDisplayedTime() {
        guard let field = textField else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        field.text = dateFormatter.string(for: picker.date)
    }

    @objc private func handleTimeChange() { updateDisplayedTime() }
    @objc private func handleTimeSelectionSubmit(_: UIAlertAction) {
        useCase.addHappening(to: event, date: picker.date)
    }

    @objc private func handleEdit() {
        viewRoot.happenings.isEditing.toggle()
    }

    @objc private func handleAdd() {
        present(makeTimeSelectionAlert(), animated: true)
    }

    deinit { print("day details controller deinit") }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DayHappeningCell.reuseIdentifier,
            for: indexPath
        ) as? DayHappeningCell else { fatalError("unable to dequeue cell") }
        cell.label.text = viewModel.items[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt index: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(
                style: .destructive,
                title: String(localizationId: "button.delete")
            ) { _, _, completion in
                let happenings = self.event.happenings(forDayComponents: self.day)
                self.useCase.removeHappening(from: self.event, happening: happenings[index.row])
                completion(true)
            },
        ])
    }
}

extension DayViewController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        guard self.event == event else { return }
        self.event = event
        viewModel = DayViewModel(day: day, event: event)
        viewRoot.happenings.reloadData()
    }
}
