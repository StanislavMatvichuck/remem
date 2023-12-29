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
        let dayIndex = pageIndex * 7 + index
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let day = startOfWeek.adding(days: dayIndex)

        return NewWeekDayViewModel(
            event: event,
            index: dayIndex,
            today: today,
            weekMaximum: weekMaximum
        ) {
            self.parent.parent.parent.coordinator.show(
                .dayDetails(factory: DayDetailsContainer(
                    parent: self.parent,
                    day: day,
                    hour: Calendar.current.component(.hour, from: self.parent.parent.parent.currentMoment),
                    minute: Calendar.current.component(.minute, from: self.parent.parent.parent.currentMoment)
                ))
            )
        }
    }
}
