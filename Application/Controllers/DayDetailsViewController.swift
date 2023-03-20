//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import UIKit

protocol DayDetailsViewModelFactoring { func makeDayViewModel() -> DayDetailsViewModel }

final class DayDetailsViewController: UIViewController {
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private var alert: UIAlertController?
    var timeInput: UITextField {
        if let textField = alert?.textFields?.first {
            return textField
        } else { fatalError("alert is not created") }
    }

    let factory: DayDetailsViewModelFactoring
    let viewRoot: DayDetailsView
    var viewModel: DayDetailsViewModel {
        didSet {
            // TODO: add test for this, time picking
            if viewModel.readableTime != oldValue.readableTime {
                timeInput.text = viewModel.readableTime
            }

            viewRoot.happenings.reloadData()
        }
    }

    // MARK: - Init
    init(_ factory: DayDetailsViewModelFactoring) {
        self.factory = factory
        self.viewRoot = DayDetailsView()
        self.viewModel = factory.makeDayViewModel()

        super.init(nibName: nil, bundle: nil)
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

    @objc func handleAdd() {
        alert = make()
        present(alert!, animated: true)
    }

    private func make() -> UIAlertController {
        let alert = UIAlertController(
            title: viewModel.create,
            message: "",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(
            title: viewModel.cancel,
            style: .cancel,
            handler: nil
        )

        let submit = UIAlertAction(
            title: viewModel.create,
            style: .default,
            handler: { [weak self] action in
                self?.handleTimeSelectionSubmit(action)
            }
        )

        alert.addAction(cancel)
        alert.addAction(submit)
        alert.addTextField { [weak self] field in
            guard let self else { return }
            field.inputView = self.picker
            field.font = .fontBold
            field.textColor = UIColor.text_primary
            field.textAlignment = .center
            field.text = self.viewModel.readableTime
        }
        return alert
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DayDetailsViewController: UITableViewDataSource, UITableViewDelegate {
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
