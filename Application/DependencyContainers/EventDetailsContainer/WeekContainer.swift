//
//  WeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class WeekContainer:
    ControllerFactoring,
    WeekViewModelFactoring,
    WeekCellViewModelFactoring,
    WeekSummaryViewModelFactoring
{
    let parent: EventDetailsContainer
    var currentMoment: Date { parent.parent.parent.currentMoment }
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var coordinator: Coordinator { parent.parent.parent.coordinator }
    var event: Event { parent.event }
    var today: DayIndex { parent.today }

    init(parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController {
        let controller = WeekViewController(self)
        updater.addDelegate(controller)
        return controller
    }

    func makeWeekViewModel(visibleDayIndex: Int? = nil) -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            weekCellFactory: self,
            weekSummaryFactory: self,
            visibleDayIndex: visibleDayIndex
        ) { amount in
            self.event.setWeeklyGoal(amount: amount, for: self.currentMoment)
            self.commander.save(self.event)
        }
    }

    func makeViewModel(day: DayIndex) -> WeekCellViewModel {
        WeekCellViewModel(
            event: event,
            day: day,
            today: today,
            tapHandler: { controller in
                self.coordinator.show(
                    Navigation.dayDetails(
                        factory: self.makeContainer(day: day),
                        week: controller
                    )
                )
            }
        )
    }

    func makeViewModel(today: DayIndex, week: WeekIndex) -> WeekSummaryViewModel {
        let startWeek = WeekIndex(event.dateCreated)
        let endWeek = WeekIndex(today.date)
        let fullTimeline = WeekTimeline<Int>(storage: [:], startIndex: startWeek, endIndex: endWeek)
        let weekTimeline = WeekTimeline<Int>(storage: [:], startIndex: startWeek, endIndex: week)
        return WeekSummaryViewModel(
            weekDate: week.date,
            event: event,
            weekNumber: weekTimeline.count,
            isCurrentWeek: fullTimeline.count == weekTimeline.count
        )
    }

    func makeContainer(day: DayIndex) -> DayDetailsContainer {
        DayDetailsContainer(
            parent: self,
            day: day,
            hour: Calendar.current.component(.hour, from: currentMoment),
            minute: Calendar.current.component(.minute, from: currentMoment)
        )
    }
}
