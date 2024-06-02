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
    EventsListFactoring,
    EventsListControllerFactoring,
    EventsListViewModelFactoring,
    HintCellViewModelFactoring,
    LoadableEventCellViewModelFactoring,
    CreateEventCellViewModelFactoring,
    CreateHappeningServiceFactoring,
    RemoveEventServiceFactoring,
    ShowEventDetailsServiceFactoring,
    EventDetailsControllerFactoringFactoring
{
    let parent: ApplicationContainer
    let sortingProvider: EventsSorterReading
    let sortingCommander: EventsSorterWriting
    let manualSortingProvider: ManualEventsSorterReading
    let manualSortingCommander: ManualEventsSorterWriting
    let goalsStorage: GoalsReading & GoalsWriting

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
        self.goalsStorage = GoalsCoreDataRepository(container: parent.coreDataContainer)
    }

    func makeEventsListController() -> EventsListController {
        let list = EventsListView.makeList()

        let dataSource = EventsListDataSource(
            list: list,
            showEventDetailsServiceFactory: self,
            createHappeningServiceFactory: self,
            removeEventServiceFactory: self,
            showCreateEventService: makeShowCreateEventService(),
            eventCellViewModelFactory: self
        )

        return EventsListController(
            viewModelFactory: self,
            view: EventsListView(list: list, dataSource: dataSource),
            showEventsOrderingService: makeShowEventsOrderingService(),
            setEventsOrderingService: makeSetEventsOrderingService()
        )
    }

    // MARK: - ViewModels factoring
    func makeEventsListViewModel() -> EventsListViewModel { EventsListViewModel(
        list: makeEventsList(),
        hintFactory: self,
        eventFactory: self,
        createEventFactory: self
    ) }

    func makeEventsList() -> EventsList { EventsList(
        sorterProvider: sortingProvider,
        manualSorterProvider: manualSortingProvider,
        eventsProvider: parent.provider
    ) }

    func makeHintCellViewModel(hint: EventsList.Hint) -> HintCellViewModel { HintCellViewModel(hint: hint) }

    func makeLoadingEventCellViewModel(eventId: String) -> LoadableEventCellViewModel {
        LoadableEventCellViewModel(loadingArguments: eventId)
    }

    func makeLoadedEventCellViewModel(eventId: String) async throws -> LoadableEventCellViewModel {
        let event = try await parent.provider.readAsync(byId: eventId)
        let goal = goalsStorage.readActiveGoal(forEvent: event)

        let cellVm = EventCellViewModel(
            event: event,
            hintEnabled: false,
            currentMoment: parent.currentMoment,
            animation: .none,
            goal: GoalViewModel(goal: goal)
        )

        return LoadableEventCellViewModel(loadingArguments: eventId, loading: false, vm: cellVm)
    }

    func makeCreateEventCellViewModel(eventsCount: Int) -> CreateEventCellViewModel {
        CreateEventCellViewModel(eventsCount: eventsCount)
    }

    // MARK: - Services factoring

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

    func makeShowEventDetailsService(id: String) -> ShowEventDetailsService { ShowEventDetailsService(
        eventId: id,
        coordinator: parent.coordinator,
        factory: self,
        eventsProvider: parent.provider
    ) }

    func makeCreateHappeningService(id: String) -> CreateHappeningService { CreateHappeningService(
        eventId: id,
        eventsStorage: parent.eventsStorage,
        eventsProvider: parent.provider
    ) }

    func makeRemoveEventService(id: String) -> RemoveEventService { RemoveEventService(
        eventId: id,
        eventsStorage: parent.eventsStorage,
        eventsProvider: parent.provider
    ) }

    // MARK: - Containers factoring
    func makeEventDetailsControllerFactoring(eventId: String) -> any EventDetailsControllerFactoring { EventDetailsContainer(parent, eventId: eventId) }
}
