//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class DayDetailsContainer:
    DayDetailsViewModelFactoring,
    DayCellViewModelFactoring
{
    let parent: EventDetailsContainer
    let startOfDay: Date

    var commander: EventsCommanding { parent.commander }
    var event: Event { parent.event }
    var currentMoment: Date { parent.currentMoment }
    var hour: Int { Calendar.current.component(.hour, from: currentMoment) }
    var minute: Int { Calendar.current.component(.minute, from: currentMoment) }

    init(_ parent: EventDetailsContainer, startOfDay: Date) {
        self.parent = parent
        self.startOfDay = startOfDay
    }

    func make() -> UIViewController { DayDetailsViewController(self) }

    private var happenings: [Happening] { event.happenings(forDayIndex: DayIndex(startOfDay)) }
    /// Storage that provides unique ids for the lifetime of presentation
    private lazy var cells: [DayCellViewModel] = {
        happenings.map { makeDayCellViewModel(happening: $0) }
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
        let id = UUID().uuidString
        return DayCellViewModel(
            id: id,
            happening: happening,
            remove: makeRemoveHappeningHandler(identifier: id, happening: happening)
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

    func makeRemoveHappeningHandler(identifier: String, happening: Happening) -> DayCellViewModel.RemoveHandler {{ [weak self] in
        if let self, let dayCellViewModelIndex = self.cells.firstIndex(where: { $0.id == identifier }) {
            self.cells.remove(at: dayCellViewModelIndex)
            do { try self.event.remove(happening: happening) } catch {}
            self.commander.save(self.event)
        }
    }}
}
