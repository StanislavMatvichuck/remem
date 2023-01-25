//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DayDetailsContainerFactoring {
    func makeContainer(event: Event, day: DayComponents) -> DayDetailsContainer
}

final class DayDetailsContainer {
    let parent: EventDetailsContainer
    let event: Event
    let day: DayComponents
    let updater: DayUpdater

    init(parent: EventDetailsContainer, event: Event, day: DayComponents) {
        self.parent = parent
        self.event = event
        self.day = day
        self.updater = DayUpdater(decoratedInterface: parent.weekViewModelUpdater)
    }

    func makeController() -> DayViewController {
        let controller = DayViewController(viewModel: makeDayViewModel(event: event, day: day))
        updater.addReceiver(receiver: controller)
        return controller
    }
}

// MARK: - ViewModelFactoring
extension DayDetailsContainer: DayViewModelFactoring, DayItemViewModelFactoring {
    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(
            day: day,
            event: event,
            commander: updater,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeDayItemViewModel(event: Event, happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: updater
        )
    }
}
