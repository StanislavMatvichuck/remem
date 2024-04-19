//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import DataLayer
import Domain
import UIKit

final class EventsListContainer:
    EventsListControllerFactoring,
    EventsListViewModelFactoring,
    HintCellViewModelFactoring,
    EventCellViewModelFactoring,
    CreateEventCellViewModelFactoring,
    CreateHappeningServiceFactoring,
    RemoveEventServiceFactoring,
    ShowEventDetailsServiceFactoring,
    EventDetailsControllerFactoringFactoring
{
    let parent: ApplicationContainer
    let sortingProvider: EventsSortingQuerying
    let sortingCommander: EventsSortingCommanding
    let manualSortingProvider: EventsSortingManualQuerying
    let manualSortingCommander: EventsSortingManualCommanding

    var uiTestingDisabled: Bool { parent.mode.uiTestingDisabled }

    init(_ parent: ApplicationContainer) {
        self.parent = parent

        let sortingRepository = EventsSorterRepository(
            parent.mode == .uikit ?
                LocalFile.eventsQuerySorter :
                LocalFile.testingEventsQuerySorter
        )

        let manualSortingRepository = EventsSorterManualRepository(
            parent.mode == .uikit ?
                LocalFile.eventsQueryManualSorter :
                LocalFile.testingEventsQueryManualSorter
        )

        self.sortingProvider = sortingRepository
        self.sortingCommander = sortingRepository
        self.manualSortingProvider = manualSortingRepository
        self.manualSortingCommander = manualSortingRepository
    }

    func makeEventsListController() -> EventsListController {
        let list = EventsListView.makeList()

        let dataSource = EventsListDataSource(
            list: list,
            viewModelProvider: self,
            showEventDetailsService: self,
            createHappeningService: self,
            removeEventService: self,
            showCreateEventService: makeShowCreateEventService()
        )

        return EventsListController(
            viewModelFactory: self,
            view: EventsListView(list: list, dataSource: dataSource),
            showEventsOrderingService: makeShowEventsOrderingService(),
            setEventsOrderingService: makeSetEventsOrderingService()
        )
    }

    // MARK: - ViewModels factoring
    func makeEventsListViewModel() -> EventsListViewModel {
        EventsListViewModel(
            list: EventsList(
                sorterProvider: sortingProvider,
                manualSorterProvider: manualSortingProvider,
                eventsProvider: parent.provider
            ),
            hintFactory: self,
            eventFactory: self,
            createEventFactory: self
        )
    }

    func makeHintCellViewModel(hint: EventsList.Hint) -> HintCellViewModel {
        HintCellViewModel(hint: hint)
    }

    func makeEventCellViewModel(eventId: String) -> EventCellViewModel {
        let event = parent.provider.read(byId: eventId)

        return EventCellViewModel(
            event: event,
            hintEnabled: false,
            currentMoment: parent.currentMoment,
            animation: .none
        )
    }

    func makeCreateEventCellViewModel(eventsCount: Int) -> CreateEventCellViewModel {
        CreateEventCellViewModel(
            eventsCount: eventsCount
        )
    }

    // MARK: - Services factoring
    func makeShowEventDetailsService(id: String) -> ShowEventDetailsService { ShowEventDetailsService(
        eventId: id,
        coordinator: parent.coordinator,
        factory: self,
        eventsProvider: parent.provider
    ) }

    func makeShowCreateEventService() -> ShowCreateEventService { ShowCreateEventService(
        coordinator: parent.coordinator,
        factory: EventCreationContainer(parent: parent),
        eventsProvider: parent.provider
    ) }

    func makeShowEventsOrderingService() -> ShowEventsOrderingService { ShowEventsOrderingService(
        coordinator: parent.coordinator,
        factory: EventsSortingContainer(self)
    ) }

    func makeSetEventsOrderingService() -> SetEventsOrderingService { SetEventsOrderingService(
        orderingRepository: sortingCommander,
        manualOrderingRepository: manualSortingCommander
    ) }

    func makeCreateHappeningService(id: String) -> CreateHappeningService { CreateHappeningService(
        eventId: id,
        eventsStorage: parent.commander,
        eventsProvider: parent.provider
    ) }

    func makeRemoveEventService(id: String) -> RemoveEventService { RemoveEventService(
        eventId: id,
        eventsStorage: parent.commander,
        eventsProvider: parent.provider
    ) }

    // MARK: - Containers factoring
    func makeEventDetailsControllerFactoring(eventId: String) -> any EventDetailsControllerFactoring { EventDetailsContainer(parent, eventId: eventId) }
}
