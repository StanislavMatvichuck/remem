//
//  NewWeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

final class NewWeekContainer:
    NewWeekViewModelFactoring,
    NewWeekDayViewModelFactoring,
    NewWeekPageViewModelFactoring
{
    private let parent: EventDetailsContainer
    private var event: Event { parent.event }
    /// This property is used for unit testing. TODO:  A single approach to all containers according to current moment must be found.
    private let today: Date

    init(_ parent: EventDetailsContainer, today: Date) {
        self.parent = parent
        self.today = today
    }

    func makeNewWeekViewModel() -> NewWeekViewModel {
        NewWeekViewModel(event: event, pageFactory: self, today: today)
    }

    func makeNewWeekPageViewModel(index: Int) -> NewWeekPageViewModel {
        NewWeekPageViewModel(event: event, dayFactory: self, index: index, today: today)
    }

    func makeNewWeekDayViewModel(index: Int, pageIndex: Int, weekMaximum: Int) -> NewWeekDayViewModel {
        NewWeekDayViewModel(
            event: event,
            index: pageIndex * 7 + index,
            today: today,
            weekMaximum: weekMaximum
        )
    }
}
