//
//  WeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import UIKit

final class WeekContainer:
    LoadableWeekViewModelFactoring,
    WeekViewModelFactoring,
    WeekDayViewModelFactoring,
    WeekPageViewModelFactoring
{
    let parent: EventDetailsContainer
    private var event: Event { parent.event }
    private var currentMoment: Date { parent.parent.currentMoment }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func makeWeekController() -> WeekController { WeekController(
        viewModelFactory: self,
        view: makeWeekView(),
        loadingHandler: parent.parent.viewModelsLoadingHandler
    ) }
    func makeWeekView() -> WeekView { WeekView(service: makeShowDayDetailsService()) }
    func makeWeekViewModel() -> WeekViewModel { WeekViewModel(event: event, pageFactory: self, createUntil: currentMoment) }
    func makeWeekPageViewModel(pageIndex: Int, dailyMaximum: Int) -> WeekPageViewModel {
        WeekPageViewModel(
            event: event,
            dayFactory: self,
            pageIndex: pageIndex,
            dailyMaximum: dailyMaximum
        )
    }

    func makeWeekDayViewModel(dayIndex: Int, dailyMaximum: Int) -> WeekDayViewModel {
        WeekDayViewModel(
            event: event,
            index: dayIndex,
            today: currentMoment,
            dailyMaximum: dailyMaximum
        )
    }

    func makeLoading() -> Loadable<WeekViewModel> { Loadable<WeekViewModel>() }
    func makeLoaded() async throws -> Loadable<WeekViewModel> {
        let event = try await parent.parent.eventsReader.readAsync(byId: parent.eventId)
        let vm = WeekViewModel(event: event, pageFactory: self, createUntil: parent.parent.currentMoment)
        return Loadable<WeekViewModel>(vm: vm)
    }

    func makeShowDayDetailsService() -> ShowDayDetailsService { ShowDayDetailsService(
        coordinator: parent.parent.coordinator,
        factory: DayDetailsPresentationContainer(parent: parent),
        eventsProvider: parent.parent.eventsReader
    ) }
}
