//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DayDetailsContainerFactoring { func makeContainer(day: DayIndex) -> DayDetailsContainer }

final class DayDetailsContainer {
    let event: Event
    let day: DayIndex
    let commander: EventsCommanding
    let updater: Updater<DayDetailsViewController, DayDetailsFactory>

    lazy var factory: DayDetailsFactory = {
        DayDetailsFactory(
            day: day,
            event: event,
            commander: commander,
            factory: self
        )
    }()

    init(event: Event, day: DayIndex, commander: EventsCommanding) {
        print("DayDetailsContainer.init")
        self.event = event
        self.day = day
        self.commander = commander
        let updater = Updater<DayDetailsViewController, DayDetailsFactory>(commander)
        self.updater = updater
        updater.factory = factory
    }

    deinit { print("DayDetailsContainer.deinit") }

    func makeController() -> DayDetailsViewController {
        let controller = DayDetailsViewController(viewModel: factory.makeViewModel())
        updater.delegate = controller
        return controller
    }
}

// MARK: - ViewModelFactoring
protocol DayItemViewModelFactoring { func makeViewModel(happening: Happening) -> DayItemViewModel }

extension DayDetailsContainer: DayItemViewModelFactoring {
    func makeViewModel(happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: updater
        )
    }
}

struct DayDetailsFactory: ViewModelFactoring {
    let day: DayIndex
    let event: Event
    let commander: EventsCommanding
    let factory: DayItemViewModelFactoring

    func makeViewModel() -> DayDetailsViewModel {
        DayDetailsViewModel(
            day: day,
            event: event,
            commander: commander,
            itemFactory: factory
        )
    }
}
