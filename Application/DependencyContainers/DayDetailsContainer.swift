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
    DayCellViewModelFactoring
{
    let parent: EventDetailsContainer

    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var event: Event { parent.event }
    var currentMoment: Date { parent.currentMoment }
    var hour: Int { Calendar.current.component(.hour, from: currentMoment) }
    var minute: Int { Calendar.current.component(.minute, from: currentMoment) }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

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
            day: DayIndex(currentMoment),
            event: event,
            isToday: false,
            hour: hour,
            minute: minute,
            itemFactory: self
        ) { date in
            self.event.addHappening(date: date)
            self.commander.save(self.event)
        }
    }
}
