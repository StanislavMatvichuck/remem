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
    WeekItemViewModelFactoring
{
    let parent: EventDetailsContainer

    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var coordinator: Coordinator { parent.parent.parent.coordinator }
    var event: Event { parent.event }
    var today: DayIndex { parent.today }
    weak var controller: WeekViewController?

    init(parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController {
        let controller = WeekViewController(self)
        updater.addDelegate(controller)
        self.controller = controller
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            itemFactory: self
        ) { amount, date in
            self.event.setWeeklyGoal(amount: amount, for: date)
            self.commander.save(self.event)
        }
    }

    func makeViewModel(day: DayIndex) -> WeekCellViewModel {
        WeekCellViewModel(
            event: event,
            day: day,
            today: today,
            tapHandler: {
                guard let controller = self.controller else { return }

                self.coordinator.show(
                    Navigation.dayDetails(
                        factory: self.makeContainer(day: day),
                        week: controller
                    )
                )
            }
        )
    }

    func makeContainer(day: DayIndex) -> DayDetailsContainer {
        DayDetailsContainer(
            parent: self,
            day: day,
            hour: Calendar.current.component(.hour, from: .now),
            minute: Calendar.current.component(.minute, from: .now)
        )
    }
}
