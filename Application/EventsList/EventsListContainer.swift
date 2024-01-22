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
    ControllerFactoring,
    EventsListViewModelFactoring,
    HintItemViewModelFactoring,
    EventCellViewModelFactoring,
    FooterItemViewModeFactoring
{
    private static let sortingExecutor = EventsSortingExecutor()

    let parent: ApplicationContainer
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
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

        let updatingSortingCommander = UpdatingEventsSortingCommander(sortingRepository)

        self.sortingProvider = sortingRepository
        self.manualSortingProvider = manualSortingRepository
        self.manualSortingCommander = manualSortingRepository
        self.sortingCommander = updatingSortingCommander
        updatingSortingCommander.delegate = updater
    }

    func make() -> UIViewController {
        let controller = EventsListViewController(
            viewModelFactory: self,
            view: EventsListView(),
            widgetUpdater: WidgetViewController()
        )

        updater.addDelegate(controller)
        return controller
    }

    func makeEventsListViewModel(_ handler: EventsListViewModelHandling?) -> EventsListViewModel {
        let sorter = sortingProvider.get()
        let events = parent.provider.get()
        let manualIdentifiers = manualSortingProvider.get()
        let sortedEvents = Self.sortingExecutor.sort(
            events: events,
            sorter: sorter,
            manualIdentifiers: manualIdentifiers
        )

        let footerVm = makeFooterItemViewModel(
            eventsCount: events.count,
            handler: handler
        )

        let hintVm = makeHintItemViewModel(events: events)

        let eventsViewModels = sortedEvents.enumerated().map { index, event in
            let userShouldSeeGestureHint = hintVm.title == HintCellViewModel.HintState.swipeFirstTime.text
            let isFirstRow = index == 0
            let hintEnabled = userShouldSeeGestureHint && isFirstRow && uiTestingDisabled

            return makeEventItemViewModel(
                event: event,
                hintEnabled: hintEnabled,
                renameHandler: handler
            )
        }

        var cells = [EventsListViewModel.Section: [AnyHashable]]()

        if uiTestingDisabled { cells.updateValue([hintVm], forKey: .hint) }

        cells.updateValue(eventsViewModels, forKey: .events)
        cells.updateValue([footerVm], forKey: .createEvent)

        let vm = EventsListViewModel(
            cells: cells,
            addHandler: makeAddEventHandler(),
            eventsSortingHandler: makeEventsSortingTapHandler(),
            manualSortingHandler: makeManualSortingHandler()
        )

        return vm
    }

    func makeHintItemViewModel(events: [Event]) -> HintCellViewModel {
        HintCellViewModel(events: events)
    }

    func makeFooterItemViewModel(
        eventsCount: Int,
        handler: FooterItemViewModelTapHandling?
    ) -> FooterCellViewModel {
        FooterCellViewModel(
            eventsCount: eventsCount,
            tapHandler: WeakRef(handler as? EventsListViewController)
        )
    }

    func makeEventItemViewModel(
        event: Event,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventCellViewModel {
        EventCellViewModel(
            event: event,
            hintEnabled: hintEnabled,
            currentMoment: parent.currentMoment,
            tapHandler: {
                self.parent.coordinator.show(.eventDetails(factory:
                    EventDetailsContainer(self.parent, event: event)
                ))
            },
            swipeHandler: {
                event.addHappening(date: self.parent.currentMoment)
                self.commander.save(event)
            },
            renameActionHandler: { renameHandler?.renameTapped($0) },
            deleteActionHandler: { self.commander.delete(event) },
            renameHandler: { newName, event in
                event.name = newName
                self.commander.save(event)
            },
            animation: .none
        )
    }

    func makeAddEventHandler() -> EventsListViewModel.AddEventHandler {{
        name in self.commander.save(Event(name: name))
    }}

    func makeManualSortingHandler() -> EventsListViewModel.ManualSortingHandler {{
        eventsIdentifiers in
        self.manualSortingCommander.set(eventsIdentifiers)
        self.sortingCommander.set(.manual)
    }}

    func makeEventsSortingTapHandler() -> EventsListViewModel.SortingTapHandler {{ topOffset in
        self.parent.coordinator.show(.eventsSorting(
            factory: EventsSortingContainer(self, topOffset: topOffset)
        ))
    }}
}
