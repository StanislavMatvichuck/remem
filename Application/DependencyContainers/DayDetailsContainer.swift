//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

final class DayDetailsContainer {
    let parent: EventDetailsContainer
    let event: Event
    let day: DayIndex
    let updater: DayDetailsUpdater

    init(parent: EventDetailsContainer, event: Event, day: DayIndex) {
        self.parent = parent
        self.event = event
        self.day = day
        self.updater = DayDetailsUpdater(decoratedInterface: parent.weekViewModelUpdater)
        updater.factory = self
    }

    func makeController() -> DayDetailsViewController {
        let controller = DayDetailsViewController(viewModel: makeViewModel())
        updater.add(receiver: controller)
        return controller
    }
}

protocol DayViewModelFactoring { func makeViewModel() -> DayDetailsViewModel }
protocol DayItemViewModelFactoring { func makeViewModel(happening: Happening) -> DayItemViewModel }

// MARK: - ViewModelFactoring
extension DayDetailsContainer:
    DayViewModelFactoring,
    DayItemViewModelFactoring
{
    func makeViewModel() -> DayDetailsViewModel {
        DayDetailsViewModel(
            day: day,
            event: event,
            commander: updater,
            itemFactory: self
        )
    }

    func makeViewModel(happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: updater
        )
    }
}
