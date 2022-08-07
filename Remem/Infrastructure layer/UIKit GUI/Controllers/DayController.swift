//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

class DayController: UIViewController {
    // MARK: - Properties
    var event: Event
    let day: DateComponents
    let editUseCase: EventEditUseCaseInput

    private let viewRoot = DayView()
    private var viewModel: DayViewModel! {
        didSet {
            viewModel.configure(viewRoot)
            viewModel.delegate = self
        }
    }

    private lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels

        if let date = Calendar.current.date(from: day) { picker.date = date }

        return picker
    }()

    private lazy var textField: UITextField? = nil {
        didSet {
            textField?.inputView = picker
            textField?.borderStyle = .none
            textField?.backgroundColor = .clear
            textField?.font = UIHelper.fontBold
            textField?.textColor = UIHelper.itemFont
            textField?.textAlignment = .center
        }
    }

    // MARK: - Init
    init(event: Event, day: DateComponents, editUseCase: EventEditUseCaseInput) {
        self.event = event
        self.day = day
        self.editUseCase = editUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }

    override func viewDidLoad() {
        view.backgroundColor = UIHelper.background
        viewModel = DayViewModel(model: event, day: day)
        configureNavBar()
        picker.addTarget(self,
                         action: #selector(handleTimeChange),
                         for: .valueChanged)
    }
}

// MARK: - Private
extension DayController {
    // Navigation bar setup
    private func configureNavBar() {
        configureTitle()
        configureEditButton()
        configureAddButton()
    }

    private func configureTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        title = dateFormatter.string(for: Calendar.current.date(from: day))
    }

    private func configureEditButton() {
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleEdit))
        navigationItem.rightBarButtonItem = editButton
    }

    private func configureAddButton() {
        let addButton = UIBarButtonItem(title: "Add",
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = addButton
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
        let date = picker.date
        editUseCase.addHappening(to: event, date: date)
    }
}

// MARK: - DayViewModelDelegate
extension DayController: DayViewModelDelegate {
    func remove(happening: Happening) {
        editUseCase.removeHappening(from: event, happening: happening)
    }
}

// MARK: - EventEditUseCaseOutput
extension DayController: EventEditUseCaseOutput {
    func updated(_ event: Event) {
        self.event = event
        viewModel = DayViewModel(model: event, day: day)
    }
}
