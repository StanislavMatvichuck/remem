//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol EventsListControllerInput: AnyObject {
    func handleSubmit(name: String)
    func addHappening(to: Event)
    func select(event: Event)
    func remove(event: Event)
    func rename(event: Event, to: String)
}

protocol EventsListControllerOutput: AnyObject {
    func update(events: [Event])
}

class EventsListController: UIViewController {
    // MARK: - Properties
    weak var coordinator: Coordinator?

    private let viewModel: EventsListControllerOutput
    private let viewRoot: EventsListViewModelOutput

    private let listUseCase: EventsListUseCaseInput
    private let editUseCase: EventEditUseCaseInput

    // MARK: - Init
    init(view: EventsListViewModelOutput,
         viewModel: EventsListControllerOutput,
         listUseCase: EventsListUseCaseInput,
         editUseCase: EventEditUseCaseInput)
    {
        viewRoot = view
        self.viewModel = viewModel
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = "Events list"
    }
}

extension EventsListController: EventsListControllerInput {
    func handleSubmit(name: String) { listUseCase.add(name: name) }
    func addHappening(to event: Event) { editUseCase.addHappening(to: event, date: .now) }
    func select(event: Event) { coordinator?.showDetails(for: event) }
    func remove(event: Event) { listUseCase.remove(event) }
    func rename(event: Event, to name: String) { editUseCase.rename(event, to: name) }
}

extension EventsListController: EventsListUseCaseOutput {
    func eventsListUpdated(_ list: [Event]) {
        viewModel.update(events: list)
    }
}

extension EventsListController: EventEditUseCaseOutput {
    func updated(event: Event) {
        viewModel.update(events: listUseCase.allEvents())
    }
}
