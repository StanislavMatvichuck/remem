//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import DataLayer
import Domain
import UIKit

typealias EventCellViewModelFactoryFactoring = (IndexPath) -> any LoadableEventCellViewModelFactoring

final class EventsListContainer:
    EventsListFactoring,
    EventsListControllerFactoring,
    EventsListViewModelFactoring,
    HintCellViewModelFactoring,
    CreateEventCellViewModelFactoring,
    EventDetailsControllerFactoringFactoring
{
    let parent: ApplicationContainer
    let orderingReader: EventsOrderingReading
    let orderingWriter: EventsOrderingWriting
    let manualOrderingReader: ManualEventsOrderingReading
    let manualOrderingWriter: ManualEventsOrderingWriting

    var eventCellViewModelFactory: (EventsListContainer) -> EventCellViewModelFactoryFactoring = { container in { indexPath in
        EventCellViewModelFactory(
            provider: container.parent.eventsReader,
            goalsStorage: container.parent.goalsReader,
            eventId: container.makeEventsList().eventsIdentifiers[indexPath.row],
            currentMoment: container.parent.currentMoment
        )
    }}

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

        self.orderingReader = sortingRepository
        self.orderingWriter = sortingRepository
        self.manualOrderingReader = manualSortingRepository
        self.manualOrderingWriter = manualSortingRepository
    }

    func makeEventsListController() -> EventsListController { EventsListController(
        viewModelFactory: self,
        view: makeEventsListView(),
        showEventsOrderingService: makeShowEventsOrderingService(),
        setEventsOrderingService: makeSetEventsOrderingService(),
        widgetService: makeWidgetService()
    ) }

    func makeEventsListView() -> EventsListView {
        let list = EventsListView.makeList()

        let dataSource = EventsListDataSource(
            list: list,
            showEventDetailsService: makeShowEventDetailsService(),
            createHappeningService: makeCreateHappeningService(),
            removeEventService: makeRemoveEventService(),
            showCreateEventService: makeShowCreateEventService(),
            eventCellViewModelFactory: eventCellViewModelFactory(self),
            loadingHandler: parent.viewModelsLoadingHandler
        )

        return EventsListView(list: list, dataSource: dataSource)
    }

    //
    // MARK: - ViewModels
    //

    func makeEventsListViewModel() -> EventsListViewModel { EventsListViewModel(
        list: makeEventsList(),
        hintFactory: self,
        createEventFactory: self
    ) }

    func makeEventsList() -> EventsList { EventsList(
        eventsReader: parent.eventsReader,
        orderingReader: orderingReader,
        manualOrderingReader: manualOrderingReader
    ) }

    func makeHintCellViewModel(hint: EventsList.Hint) -> HintCellViewModel { HintCellViewModel(hint: hint) }

    func makeCreateEventCellViewModel(eventsCount: Int) -> CreateEventCellViewModel {
        CreateEventCellViewModel(eventsCount: eventsCount)
    }

    //
    // MARK: - Services
    //

    func makeShowCreateEventService() -> ShowCreateEventService { ShowCreateEventService(
        coordinator: parent.coordinator,
        factory: EventCreationContainer(parent: parent),
        eventsProvider: parent.eventsReader
    ) }

    func makeShowEventsOrderingService() -> ShowEventsOrderingService { ShowEventsOrderingService(
        coordinator: parent.coordinator,
        factory: EventsSortingContainer(self)
    ) }

    func makeSetEventsOrderingService() -> SetEventsOrderingService { SetEventsOrderingService(
        orderingRepository: orderingWriter,
        manualOrderingRepository: manualOrderingWriter
    ) }

    func makeShowEventDetailsService() -> ShowEventDetailsService { ShowEventDetailsService(
        coordinator: parent.coordinator,
        factory: self,
        eventsProvider: parent.eventsReader
    ) }

    func makeCreateHappeningService() -> CreateHappeningService { CreateHappeningService(
        eventsStorage: parent.eventsWriter,
        eventsProvider: parent.eventsReader
    ) }

    func makeRemoveEventService() -> RemoveEventService { RemoveEventService(
        eventsStorage: parent.eventsWriter,
        eventsProvider: parent.eventsReader
    ) }

    func makeWidgetService() -> WidgetService { WidgetService(
        eventsListFactory: self,
        eventCellFactory: eventCellViewModelFactory(self)
    ) }

    //
    // MARK: - Containers
    //

    func makeEventDetailsControllerFactoring(eventId: String) -> any EventDetailsControllerFactoring { EventDetailsContainer(parent, eventId: eventId) }
}

struct EventCellViewModelFactory: LoadableEventCellViewModelFactoring {
    let provider: EventsReading
    let goalsStorage: GoalsReading
    let eventId: String
    let currentMoment: Date

    func makeLoading() -> Loadable<EventCellViewModel> { Loadable<EventCellViewModel>() }
    func makeLoaded() async throws -> Loadable<EventCellViewModel> {
        let event = try await provider.readAsync(byId: eventId)
        let goal = goalsStorage.readActiveGoal(forEvent: event)

        let cellVm = EventCellViewModel(
            event: event,
            hintEnabled: false,
            currentMoment: currentMoment,
            animation: .none,
            goal: GoalViewModel(goal: goal)
        )

        return Loadable<EventCellViewModel>(vm: cellVm)
    }
}
