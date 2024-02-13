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
    let startOfDay: Date

    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var event: Event { parent.event }
    var currentMoment: Date { parent.currentMoment }
    var hour: Int { Calendar.current.component(.hour, from: currentMoment) }
    var minute: Int { Calendar.current.component(.minute, from: currentMoment) }

    init(_ parent: EventDetailsContainer, startOfDay: Date) {
        self.parent = parent
        self.startOfDay = startOfDay
    }

    func make() -> UIViewController {
        let controller = DayDetailsViewController(self)
        updater.addDelegate(controller)
        return controller
    }

    private var happenings: [Happening] { event.happenings(forDayIndex: DayIndex(startOfDay)) }
    /// Storage that provides unique ids for the lifetime of presentation
    private lazy var cells: [DayCellViewModel] = {
        happenings.map { happening in
            makeDayCellViewModel(happening: happening)
        }
    }()

    // MARK: - ViewModels

    func makeDayDetailsViewModel(pickerDate: Date?) -> DayDetailsViewModel {
        return DayDetailsViewModel(
            currentMoment: currentMoment,
            startOfDay: startOfDay,
            pickerDate: pickerDate,
            cells: cells,
            addHappeningHandler: makeAddHappeningHandler()
        )
    }

    func makeDayCellViewModel(happening: Happening) -> DayCellViewModel {
        DayCellViewModel(
            id: UUID(),
            happening: happening,
            remove: makeRemoveHappeningHandler()
        )
    }

    // MARK: - Handlers

    func makeAddHappeningHandler() -> DayDetailsViewModel.AddHappeningHandler { { date in
        let event = self.event
        let happening = event.addHappening(date: date)

        if let index = self.happenings.lastIndex(of: happening) {
            self.cells.insert(self.makeDayCellViewModel(happening: happening), at: index)
        }

        self.commander.save(event)
    }}

    func makeRemoveHappeningHandler() -> DayCellViewModel.RemoveHandler {{ cell, happening in
        if let index = self.cells.firstIndex(of: cell) {
            self.cells.remove(at: index)
        }

        do { try self.event.remove(happening: happening) } catch {}
        self.commander.save(self.event)
    }}
}
