//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import IOSInterfaceAdapters
import UIKit

class DayController: UIViewController {
    // MARK: - Properties
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private lazy var textField: UITextField? = nil {
        didSet {
            textField?.inputView = picker
            textField?.font = UIHelper.fontBold
            textField?.textColor = UIHelper.itemFont
            textField?.textAlignment = .center
        }
    }

    private let viewRoot: DayView
    private let viewModel: DayViewModeling

    // MARK: - Init
    init(viewRoot: DayView, viewModel: DayViewModeling) {
        self.viewRoot = viewRoot
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureNavBar()
        viewRoot.happenings.dataSource = self
        picker.date = viewModel.date
        picker.addTarget(self, action: #selector(handleTimeChange), for: .valueChanged)
    }
}

// MARK: - UITableViewDataSource
extension DayController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { viewModel.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayHappeningCell.reuseIdentifier, for: indexPath)
            as? DayHappeningCell else { return UITableViewCell() }
        cell.label.text = viewModel.time(at: indexPath.row)
        return cell
    }

    // Cells deletion
    func tableView(_: UITableView, commit _: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.remove(at: indexPath.row)
    }
}

extension DayController: DayViewModelDelegate {
    func update() { viewRoot.happenings.reloadData() }
}

// MARK: - Private
extension DayController {
    // Navigation bar setup
    private func configureNavBar() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleAdd))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEdit))
    }

    // Navigation bar events handling
    @objc private func handleEdit() {
        viewRoot.happenings.isEditing.toggle()
    }

    @objc private func handleAdd() {
        let alert = makeTimeSelectionAlert()
        present(alert, animated: true)
    }

    // Time selection alert
    private func makeTimeSelectionAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Add a happening",
                                      message: nil,
                                      preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Add", style: .default, handler: handleTimeSelectionSubmit)

        alert.addTextField { field in self.textField = field }
        alert.addAction(cancel)
        alert.addAction(submit)

        return alert
    }

    @objc private func handleTimeChange() { updateDisplayedTime() }

    private func updateDisplayedTime() {
        guard let field = textField else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        field.text = dateFormatter.string(for: picker.date)
    }

    @objc private func handleTimeSelectionSubmit(_: UIAlertAction) {
        viewModel.add(at: picker.date)
    }
}
