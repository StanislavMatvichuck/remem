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

    init(_ parent: EventDetailsContainer, startOfDay: Date) {
        self.parent = parent
        self.startOfDay = startOfDay
    }

    func makeDayDetailsController() -> DayDetailsController { DayDetailsController(
        self,
        createHappeningService: makeCreateHappeningService(),
        removeHappeningService: makeRemoveHappeningService()
    ) }

    func makeDayDetailsViewModel(pickerDate: Date?) -> DayDetailsViewModel {
        DayDetailsViewModel(
            currentMoment: parent.parent.currentMoment,
            startOfDay: startOfDay,
            pickerDate: pickerDate,
            cells: parent.event.happenings(forDayIndex: DayIndex(startOfDay)).map { makeDayCellViewModel(happening: $0) }
        )
    }

    func makeDayCellViewModel(happening: Happening) -> DayCellViewModel { DayCellViewModel(id: UUID().uuidString, happening: happening) }
    func makeCreateHappeningService() -> CreateHappeningService { CreateHappeningService(
        eventId: parent.eventId,
        eventsStorage: parent.parent.eventsStorage,
        eventsProvider: parent.parent.provider
    ) }

    func makeRemoveHappeningService() -> RemoveHappeningService { RemoveHappeningService(
        eventId: parent.eventId,
        eventsStorage: parent.parent.eventsStorage,
        eventsProvider: parent.parent.provider
    ) }
}
