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
            commander: updater,
            factory: self
        )
    }()

    init(event: Event, day: DayIndex, commander: EventsCommanding) {
        self.event = event
        self.day = day
        self.commander = commander
        self.updater = Updater(commander)
        updater.factory = factory
    }

    func makeController() -> DayDetailsViewController {
        let controller = DayDetailsViewController(viewModel: factory.makeViewModel())
        updater.receiver = controller
        return controller
    }
}

// MARK: - ViewModelFactoring
protocol DayViewModelFactoring { func makeViewModel() -> DayDetailsViewModel }
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
