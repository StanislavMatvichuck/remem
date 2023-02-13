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
    let parent: ApplicationContainer
    let updater: EventsListUpdater

    init(applicationContainer: ApplicationContainer) {
        let widgetUpdater = WidgetUpdater(provider: applicationContainer.provider,
                                          decorated: applicationContainer.commander)

        let controllerUpdater = EventsListUpdater(
            decorated: widgetUpdater,
            eventsProvider: applicationContainer.provider
        )

        parent = applicationContainer
        updater = controllerUpdater

        applicationContainer.coordinator.eventDetailsFactory = self
        controllerUpdater.factory = self
        widgetUpdater.factory = self
    }

    func makeController() -> EventsListViewController {
        let controller = EventsListViewController(
            viewModel: makeEventsListViewModel(events: parent.provider.get())
        )
        updater.add(receiver: controller)
        return controller
    }
}

// MARK: - ViewModels factoring
extension EventsListContainer:
    EventsListViewModelFactoring,
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring
{
    func makeEventsListViewModel(events: [Event]) -> EventsListViewModel {
        let today = DayIndex(.now)

        let footerVm = makeFooterItemViewModel(eventsCount: events.count)
        let hintVm = makeHintItemViewModel(events: events)

        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text
        let eventsVm = events.map { makeEventItemViewModel(
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
            commander: updater,
            items: items
        )

        return vm
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
            coordinator: parent.coordinator,
            commander: updater
        )
    }
}

extension EventsListContainer: EventDetailsContainerFactoring {
    func makeContainer(event: Event, today: DayIndex) -> EventDetailsContainer {
        EventDetailsContainer(parent: self, event: event, today: today)
    }
}
