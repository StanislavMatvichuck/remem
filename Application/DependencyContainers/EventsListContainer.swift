//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import Domain
import Foundation
import UIKit

protocol HintItemViewModelFactoring { func makeHintItemViewModel(events: [Event]) -> HintItemViewModel }
protocol EventItemViewModelFactoring { func makeEventItemViewModel(event: Event, today: DayIndex, hintEnabled: Bool) -> EventItemViewModel }
protocol FooterItemViewModeFactoring { func makeFooterItemViewModel(eventsCount: Int) -> FooterItemViewModel }

final class EventsListContainer:
    ControllerFactoring,
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring
{
    let parent: ApplicationContainer
    let widgetViewController: WidgetViewController /// more like application-level dependency

    var provider: EventsQuerying { parent.provider }
    var coordinator: Coordinator { parent.coordinator }

    lazy var updater: Updater<EventsListViewController, EventsListViewModelFactory> = {
        let widgetUpdater = Updater<WidgetViewController, WidgetViewModelFactory>(parent.commander)
        widgetUpdater.delegate = widgetViewController
        widgetUpdater.factory = widgetViewModelFactory

        let listUpdater = Updater<EventsListViewController, EventsListViewModelFactory>(widgetUpdater)
        listUpdater.factory = listViewModelFactory

        return listUpdater
    }()

    lazy var listViewModelFactory: EventsListViewModelFactory = {
        EventsListViewModelFactory(parent: self)
    }()

    lazy var widgetViewModelFactory: WidgetViewModelFactory = {
        WidgetViewModelFactory(parent: self)
    }()

    init(parent: ApplicationContainer) {
        print("EventsListContainer.init")

        self.parent = parent
        self.widgetViewController = WidgetViewController()
    }

    deinit { print("EventsListContainer.deinit") }

    func make() -> UIViewController {
        let controller = EventsListViewController(viewModel: listViewModelFactory.makeViewModel())
        updater.delegate = controller
        return controller
    }

    func makeHintItemViewModel(events: [Event]) -> HintItemViewModel {
        HintItemViewModel(events: events)
    }

    func makeFooterItemViewModel(eventsCount: Int) -> FooterItemViewModel {
        FooterItemViewModel(
            eventsCount: eventsCount
        )
    }

    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool
    ) -> EventItemViewModel {
        EventItemViewModel(
            event: event,
            today: today,
            hintEnabled: hintEnabled,
            coordinator: coordinator,
            commander: updater,
            tapHandler: {
                self.coordinator.show(Navigation.eventDetails(
                    factory: self.makeContainer(
                        event: event,
                        today: today
                    ))
                )
            }
        )
    }

    func makeContainer(event: Event, today: DayIndex) -> EventDetailsContainer {
        EventDetailsContainer(
            parent: self,
            event: event,
            today: today
        )
    }
}

final class EventsListViewModelFactory: ViewModelFactoring {
    unowned let parent: EventsListContainer

    init(parent: EventsListContainer) { self.parent = parent }

    func makeViewModel() -> EventsListViewModel {
        let today = DayIndex(.now)
        let events = parent.provider.get()

        let footerVm = parent.makeFooterItemViewModel(eventsCount: events.count)
        let hintVm = parent.makeHintItemViewModel(events: events)

        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text
        let eventsVm = events.map { parent.makeEventItemViewModel(
            event: $0,
            today: today,
            hintEnabled: gestureHintEnabled
        ) }

        var items = [any EventsListItemViewModeling]()
        items.append(hintVm)
        items.append(contentsOf: eventsVm)
        items.append(footerVm)

        let vm = EventsListViewModel(
            today: today,
            commander: parent.updater,
            items: items
        )

        return vm
    }
}

final class WidgetViewModelFactory: ViewModelFactoring {
    unowned let parent: EventsListContainer

    init(parent: EventsListContainer) { self.parent = parent }

    func makeViewModel() -> [EventItemViewModel] {
        let listVm: EventsListViewModel = parent.listViewModelFactory.makeViewModel()
        let items = listVm.items.filter { type(of: $0) is EventItemViewModel.Type } as! [EventItemViewModel]
        return items
    }
}
