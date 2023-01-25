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
    let day: DayComponents
    let updater: DayUpdater

    init(parent: EventDetailsContainer, event: Event, day: DayComponents) {
        self.parent = parent
        self.event = event
        self.day = day
        self.updater = DayUpdater(decoratedInterface: parent.weekViewModelUpdater)
        updater.factory = self
    }

    func makeController() -> DayViewController {
        let controller = DayViewController(viewModel: makeViewModel())
        updater.add(receiver: controller)
        return controller
    }
}

protocol DayViewModelFactoring { func makeViewModel() -> DayViewModel }
protocol DayItemViewModelFactoring { func makeViewModel(happening: Happening) -> DayItemViewModel }

// MARK: - ViewModelFactoring
extension DayDetailsContainer:
    DayViewModelFactoring,
    DayItemViewModelFactoring
{
    func makeViewModel() -> DayViewModel {
        DayViewModel(
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
