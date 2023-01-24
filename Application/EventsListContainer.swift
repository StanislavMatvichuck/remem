//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import Domain
import Foundation

final class EventsListContainer {
    var applicationContainer: ApplicationContainer
    var updater: EventsListUpdater

    init(applicationContainer: ApplicationContainer) {
        self.applicationContainer = applicationContainer
        self.updater = EventsListUpdater(
            decorated: applicationContainer.commander,
            eventsProvider: applicationContainer.provider
        )
        updater.factory = self
    }
}

// MARK: - ViewController factoring
protocol EventsListViewControllerFactoring {
    func makeEventsListViewController(events: [Event]) -> EventsListViewController
}

extension EventsListContainer: EventsListViewControllerFactoring {
    func makeEventsListViewController(events: [Event]) -> EventsListViewController {
        let providers: [EventsListItemProviding] = [
            HintItemProvider(),
            EventItemProvider(),
            FooterItemProvider(),
        ]
        let controller = EventsListViewController(
            viewModel: makeEventsListViewModel(events: events),
            providers: providers
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
        let today = DayComponents(date: .now)
        let footerVm = makeFooterItemViewModel(eventsCount: events.count)
        let hintVm = makeHintItemViewModel(events: events)
        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text

        let vm = EventsListViewModel(
            today: today,
            commander: updater,
            sections: [
                [hintVm],
                events.map {
                    makeEventItemViewModel(
                        event: $0,
                        today: today,
                        hintEnabled: gestureHintEnabled
                    )
                },
                [footerVm],
            ]
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
        today: DayComponents,
        hintEnabled: Bool
    ) -> EventItemViewModel {
        EventItemViewModel(
            event: event,
            today: today,
            hintEnabled: hintEnabled,
            coordinator: applicationContainer.coordinator,
            commander: updater
        )
    }
}
