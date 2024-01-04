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
    private var currentMoment: Date { parent.parent.currentMoment }
    private var coordinator: Coordinator { parent.parent.coordinator }
    private var updater: ViewControllersUpdater { parent.parent.updater }
    private var calendar: Calendar { Calendar.current }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController {
        let controller = WeekViewController(self)
        updater.addDelegate(WeakRef(controller))
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        WeekViewModel(event: event, pageFactory: self, createUntil: currentMoment)
    }

    func makeWeekPageViewModel(pageIndex: Int, dailyMaximum: Int) -> WeekPageViewModel {
        WeekPageViewModel(
            event: event,
            dayFactory: self,
            pageIndex: pageIndex,
            dailyMaximum: dailyMaximum
        )
    }

    func makeWeekDayViewModel(dayIndex: Int, dailyMaximum: Int) -> WeekDayViewModel {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let day = startOfWeek.adding(days: dayIndex)

        return WeekDayViewModel(
            event: event,
            index: dayIndex,
            today: currentMoment,
            dailyMaximum: dailyMaximum
        ) { presentationAnimation, dismissAnimation in
            let dayDetailsContainer = DayDetailsContainer(
                parent: self.parent,
                day: day,
                hour: self.calendar.component(.hour, from: self.currentMoment),
                minute: self.calendar.component(.minute, from: self.currentMoment)
            )

            let presentationContainer = DayDetailsPresentationContainer(
                parent: self.parent,
                dayDetailsContainer: dayDetailsContainer,
                presentationAnimator: DayDetailsPresentationAnimator()
            )

            presentationContainer.cellPresentationAnimationBlock = presentationAnimation
            presentationContainer.cellDismissAnimationBlock = dismissAnimation

            self.coordinator.show(.dayDetails(
                factory: presentationContainer
            ))
        }
    }
}
