//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
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

    let viewRoot: DayView
    var viewModel: DayViewModel

    // MARK: - Init
    init(viewModel: DayViewModel) {
        self.viewRoot = DayView()
        self.viewModel = viewModel
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

    private func makeTimeSelectionAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: viewModel.create,
            message: nil,
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
            handler: handleTimeSelectionSubmit
        )

        alert.addTextField { field in self.textField = field }
        alert.addAction(cancel)
        alert.addAction(submit)

        return alert
    }

    // TODO: Move this logic to viewModel
    private func updateDisplayedTime() {
        guard let field = textField else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        field.text = dateFormatter.string(for: picker.date)
    }

    @objc private func handleTimeChange() { updateDisplayedTime() }
    @objc private func handleTimeSelectionSubmit(_: UIAlertAction) {
        viewModel.addHappening()
    }

    @objc private func handleEdit() {
        viewRoot.happenings.isEditing.toggle()
    }

    @objc private func handleAdd() {
        present(makeTimeSelectionAlert(), animated: true)
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

extension DayViewController: DayViewModelUpdating {
    var currentViewModel: DayViewModel { viewModel }

    func update(viewModel: DayViewModel) {
        self.viewModel = viewModel
        viewRoot.happenings.reloadData()
    }
}
