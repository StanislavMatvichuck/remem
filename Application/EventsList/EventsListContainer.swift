//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import DataLayer
import Domain
import UIKit

typealias EventCellViewModelFactoryFactoring = (String) -> any LoadableEventCellViewModelFactoring

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

    func makeEventsListController() -> EventsListController {
        let list = EventsListView.makeList()
        let viewModel = makeEventsListViewModel()

        return EventsListController(
            viewModelFactory: self,
            view: makeEventsListView(list: list, viewModel: viewModel),
            showEventsOrderingService: makeShowEventsOrderingService(),
            setEventsOrderingService: makeSetEventsOrderingService(),
            widgetService: makeWidgetService(),
            dataSource: makeDataSource(list: list, viewModel: viewModel)
        )
    }

    func makeEventsListView(list: UICollectionView, viewModel: EventsListViewModel) -> EventsListView {
        EventsListView(list: list, viewModel: viewModel)
    }

    func makeDataSource(list: UICollectionView, viewModel: EventsListViewModel) -> EventsListDataSource { EventsListDataSource(
        list: list,
        showEventDetailsService: makeShowEventDetailsService(),
        createHappeningService: makeCreateHappeningService(),
        removeEventService: makeRemoveEventService(),
        showCreateEventService: makeShowCreateEventService(),
        eventCellViewModelFactory: { eventId in
            EventCellViewModelFactory(
                provider: self.parent.eventsReader,
                goalsStorage: self.parent.goalsReader,
                eventId: eventId,
                currentMoment: self.parent.currentMoment
            )
        },
        loadingHandler: parent.viewModelsLoadingHandler,
        viewModel: viewModel
    ) }

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
        eventCellFactory: { eventId in
            EventCellViewModelFactory(
                provider: self.parent.eventsReader,
                goalsStorage: self.parent.goalsReader,
                eventId: eventId,
                currentMoment: self.parent.currentMoment
            )
        }
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
