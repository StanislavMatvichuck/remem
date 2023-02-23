//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import Domain
import Foundation
import UIKit

protocol EventsListContainerFactoring {
    func makeContainer() -> EventsListContainer
}

final class EventsListContainer {
    let provider: EventsQuerying
    let coordinator: DefaultCoordinator
    let updater: Updater<EventsListViewController, EventsListFactory>

    lazy var factory: EventsListFactory = {
        EventsListFactory(
            provider: provider,
            commander: updater,
            footerItemFactory: self,
            hintItemFactory: self,
            eventItemFactory: self
        )
    }()

    init(
        provider: EventsQuerying,
        commander: EventsCommanding,
        coordinator: DefaultCoordinator
    ) {
        self.provider = provider
        self.coordinator = coordinator
        let widgetUpdater = Updater<WidgetViewController, WidgetFactory>(commander)
        widgetUpdater.receiver = WidgetViewController()

        let controllerUpdater = Updater<EventsListViewController, EventsListFactory>(widgetUpdater)

        updater = controllerUpdater

        coordinator.eventDetailsFactory = self

        controllerUpdater.factory = factory
        widgetUpdater.factory = WidgetFactory(factory: factory)
    }

    func makeController() -> EventsListViewController {
        let controller = EventsListViewController(viewModel: factory.makeViewModel())
        updater.receiver = controller
        return controller
    }
}

extension EventsListContainer: EventDetailsContainerFactoring {
    func makeContainer(event: Event, today: DayIndex) -> EventDetailsContainer {
        EventDetailsContainer(
            event: event,
            today: today,
            commander: updater,
            coordinator: coordinator
        )
    }
}

// MARK: - ViewModels factoring
protocol HintItemViewModelFactoring { func makeHintItemViewModel(events: [Event]) -> HintItemViewModel }
protocol EventItemViewModelFactoring { func makeEventItemViewModel(event: Event, today: DayIndex, hintEnabled: Bool) -> EventItemViewModel }
protocol FooterItemViewModeFactoring { func makeFooterItemViewModel(eventsCount: Int) -> FooterItemViewModel }

extension EventsListContainer:
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring
{
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
            commander: updater
        )
    }
}

struct EventsListFactory: ViewModelFactoring {
    let provider: EventsQuerying
    let commander: EventsCommanding
    let footerItemFactory: FooterItemViewModeFactoring
    let hintItemFactory: HintItemViewModelFactoring
    let eventItemFactory: EventItemViewModelFactoring

    func makeViewModel() -> EventsListViewModel {
        let today = DayIndex(.now)
        let events = provider.get()

        let footerVm = footerItemFactory.makeFooterItemViewModel(eventsCount: events.count)
        let hintVm = hintItemFactory.makeHintItemViewModel(events: events)

        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text
        let eventsVm = events.map { eventItemFactory.makeEventItemViewModel(
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
            commander: commander,
            items: items
        )

        return vm
    }
}

struct WidgetFactory: ViewModelFactoring {
    let factory: EventsListFactory

    func makeViewModel() -> [EventItemViewModel] {
        let listVm: EventsListViewModel = factory.makeViewModel()
        let items = listVm.items.filter { type(of: $0) is EventItemViewModel.Type } as! [EventItemViewModel]
        return items
    }
}
