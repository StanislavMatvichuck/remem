//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import UIKit

class DayViewController:
    UIViewController,
    UsingEventDependantViewModel
{
    // MARK: - Properties
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let alert: UIAlertController
    var timeInput: UITextField { alert.textFields!.first! }
    let viewRoot: DayView
    var viewModel: DayViewModel {
        didSet {
            viewRoot.happenings.reloadData()
            timeInput.text = viewModel.readableTime
        }
    }

    // MARK: - Init
    init(viewModel: DayViewModel) {
        self.viewRoot = DayView()
        self.viewModel = viewModel
        self.alert = UIAlertController(
            title: viewModel.create,
            message: nil,
            preferredStyle: .alert
        )

        super.init(nibName: nil, bundle: nil)

        let cancel = UIAlertAction(
            title: viewModel.cancel,
            style: .cancel,
            handler: nil
        )

        let submit = UIAlertAction(
            title: viewModel.create,
            style: .default,
            handler: handleTimeSelectionSubmit
        )

        alert.addAction(cancel)
        alert.addAction(submit)
        alert.addTextField { field in
            field.inputView = self.picker
            field.font = UIHelper.fontBold
            field.textColor = UIHelper.itemFont
            field.textAlignment = .center
            field.text = viewModel.readableTime
        }
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
        picker.date = viewModel.pickerDate
        picker.addTarget(self, action: #selector(handleTimeChange), for: .valueChanged)
    }

    private func configureTableView() {
        viewRoot.happenings.dataSource = self
        viewRoot.happenings.delegate = self
    }

    private func configureNavBar() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: viewModel.create,
            style: .plain,
            target: self,
            action: #selector(handleAdd)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: viewModel.edit,
            style: .plain,
            target: self,
            action: #selector(handleEdit)
        )
    }

    @objc private func handleTimeChange() {
        viewModel.update(pickerDate: picker.date)
    }

    @objc private func handleTimeSelectionSubmit(_: UIAlertAction) {
        viewModel.addHappening()
    }

    @objc private func handleEdit() {
        viewRoot.happenings.isEditing.toggle()
    }

    @objc private func handleAdd() {
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DayItem.reuseIdentifier,
            for: indexPath
        ) as? DayItem else { fatalError("unable to dequeue cell") }
        cell.label.text = viewModel.items[indexPath.row].text
        return cell
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt index: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(
                style: .destructive,
                title: viewModel.delete
            ) { _, _, completion in
                self.viewModel.items[index.row].remove()
                completion(true)
            },
        ])
    }
}
