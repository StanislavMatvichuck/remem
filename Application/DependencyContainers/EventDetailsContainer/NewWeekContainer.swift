//
//  NewWeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import UIKit

final class NewWeekContainer:
    ControllerFactoring,
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

    func make() -> UIViewController {
        let controller = NewWeekViewController(self)
        return controller
    }

    func makeNewWeekViewModel() -> NewWeekViewModel {
        NewWeekViewModel(event: event, pageFactory: self, today: today)
    }

    func makeNewWeekPageViewModel(pageIndex: Int) -> NewWeekPageViewModel {
        let startWeekIndex = WeekIndex(event.dateCreated)
        let today = startWeekIndex.dayIndex.adding(days: pageIndex * 7)
        return NewWeekPageViewModel(
            event: event,
            dayFactory: self,
            pageIndex: pageIndex,
            today: today.date
        )
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
