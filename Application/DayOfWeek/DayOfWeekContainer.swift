//
//  DayOfWeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekContainer: LoadableDayOfWeekViewModelFactoring {
    private let parent: EventDetailsContainer

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func makeDayOfWeekController() -> DayOfWeekController { DayOfWeekController(
        viewModelFactory: self,
        loadingHandler: parent.parent.viewModelsLoadingHandler
    ) }

    func makeDayOfWeekViewModel() -> DayOfWeekViewModel { DayOfWeekViewModel(
        parent.event.happenings,
        currentMoment: parent.parent.currentMoment
    ) }

    func makeLoaded() async throws -> Loadable<DayOfWeekViewModel> {
        let event = try await parent.parent.eventsReader.readAsync(byId: parent.eventId)
        let vm = DayOfWeekViewModel(event.happenings, currentMoment: parent.parent.currentMoment)
        return Loadable<DayOfWeekViewModel>(vm: vm)
    }
}
