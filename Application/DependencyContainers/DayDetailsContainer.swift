//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class DayDetailsContainer:
    ControllerFactoring,
    DayDetailsViewModelFactoring,
    DayItemViewModelFactoring
{
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var event: Event { parent.event }

    let parent: WeekContainer
    let day: DayIndex
    let hour: Int
    let minute: Int

    init(
        parent: WeekContainer,
        day: DayIndex,
        hour: Int,
        minute: Int
    ) {
        self.parent = parent
        self.day = day
        self.hour = hour
        self.minute = minute
    }

    func make() -> UIViewController {
        let controller = DayDetailsViewController(self)
        updater.addDelegate(controller)
        return controller
    }

    func makeViewModel(happening: Happening) -> DayCellViewModel {
        DayCellViewModel(happening: happening) { happening in
            do { try self.event.remove(happening: happening) } catch {}
            self.commander.save(self.event)
        }
    }

    func makeDayDetailsViewModel() -> DayDetailsViewModel {
        DayDetailsViewModel(
            day: day,
            event: event,
            isToday: day == parent.today,
            hour: hour,
            minute: minute,
            commander: commander,
            itemFactory: self
        )
    }
}
