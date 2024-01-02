//
//  WeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import UIKit

final class WeekContainer:
    ControllerFactoring,
    WeekViewModelFactoring,
    WeekDayViewModelFactoring,
    WeekPageViewModelFactoring
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
        let controller = WeekViewController(self)
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        WeekViewModel(event: event, pageFactory: self, today: today)
    }

    func makeWeekPageViewModel(pageIndex: Int) -> WeekPageViewModel {
        let startWeekIndex = WeekIndex(event.dateCreated)
        let today = startWeekIndex.dayIndex.adding(days: pageIndex * 7)
        return WeekPageViewModel(
            event: event,
            dayFactory: self,
            pageIndex: pageIndex,
            today: today.date
        )
    }

    func makeWeekDayViewModel(
        dayNumberInWeek: Int,
        pageIndex: Int,
        weekMaximum: Int
    ) -> WeekDayViewModel {
        let dayIndex = pageIndex * 7 + dayNumberInWeek
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let day = startOfWeek.adding(days: dayIndex)

        return WeekDayViewModel(
            event: event,
            index: dayIndex,
            today: today,
            weekMaximum: weekMaximum
        ) { presentationAnimation, dismissAnimation in
            let dayDetailsContainer = DayDetailsContainer(
                parent: self.parent,
                day: day,
                hour: Calendar.current.component(.hour, from: self.parent.parent.parent.currentMoment),
                minute: Calendar.current.component(.minute, from: self.parent.parent.parent.currentMoment)
            )

            let presentationContainer = DayDetailsPresentationContainer(
                parent: self.parent,
                dayDetailsContainer: dayDetailsContainer,
                presentationAnimator: DayDetailsPresentationAnimator(originHeight: 100)
            )

            presentationContainer.cellPresentationAnimationBlock = presentationAnimation
            presentationContainer.cellDismissAnimationBlock = dismissAnimation

            self.parent.parent.parent.coordinator.show(.dayDetails(
                factory: presentationContainer
            ))
        }
    }
}
