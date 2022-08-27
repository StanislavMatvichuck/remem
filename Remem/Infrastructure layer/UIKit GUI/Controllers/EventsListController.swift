//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol EventsListControllerOutput: AnyObject {
    func added(event: Event, newList: [Event])
    func removed(event: Event, newList: [Event])
    func updated(event: Event, newList: [Event])
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

protocol EventsListControllerInput: AnyObject {
    func addEvent(name: String)
    func addHappening(to: Event)
    func select(event: Event)
    func remove(event: Event)
    func rename(event: Event, to: String)
}

extension EventsListController: EventsListControllerInput {
    func addEvent(name: String) {
        listUseCase.add(name: name)
    }

    func addHappening(to event: Event) {
        editUseCase.addHappening(to: event, date: .now)
    }

    func select(event: Event) {
        coordinator?.showDetails(for: event)
    }

    func remove(event: Event) {
        listUseCase.remove(event)
    }

    func rename(event: Event, to name: String) {
        editUseCase.rename(event, to: name)
    }
}

extension EventsListController: EventsListUseCaseOutput {
    func added(event: Event) {
        viewModel.added(event: event, newList: listUseCase.allEvents())
    }

    func removed(event: Event) {
        viewModel.removed(event: event, newList: listUseCase.allEvents())
    }
}

extension EventsListController: EventEditUseCaseOutput {
    func updated(event: Event) {
        viewModel.updated(event: event, newList: listUseCase.allEvents())
    }
}
