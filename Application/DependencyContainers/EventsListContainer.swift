//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import Domain
import Foundation
import UIKit

final class EventsListContainer:
    ControllerFactoring,
    EventsListViewModelFactoring,
    WidgetViewModelFactoring,
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring
{
    let commander: UpdatingCommander
    let parent: ApplicationContainer

    init(parent: ApplicationContainer) {
        self.parent = parent
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let controller = EventsListViewController(self, self)
        commander.delegate = controller
        return controller
    }

    func makeEventsListViewModel(_ handler: EventsListViewModelHandling?) -> EventsListViewModel {
        let today = DayIndex(.now)
        let events = parent.provider.get()

        let footerVm = makeFooterItemViewModel(
            eventsCount: events.count,
            handler: handler
        )

        let hintVm = makeHintItemViewModel(events: events)

        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text // make this for first row only

        let eventsViewModels = events.map {
            makeEventItemViewModel(
                event: $0,
                today: today,
                hintEnabled: gestureHintEnabled,
                renameHandler: handler
            )
        }

        var items = [any EventsListItemViewModeling]()
        items.append(hintVm)
        items.append(contentsOf: eventsViewModels)
        items.append(footerVm)

        let vm = EventsListViewModel(
            today: today,
            commander: commander,
            items: items
        )

        return vm
    }

    func makeHintItemViewModel(events: [Event]) -> HintItemViewModel {
        HintItemViewModel(events: events)
    }

    func makeFooterItemViewModel(
        eventsCount: Int,
        handler: FooterItemViewModelTapHandling?
    ) -> FooterItemViewModel {
        FooterItemViewModel(
            eventsCount: eventsCount,
            tapHandler: WeakRef(handler as? EventsListViewController)
        )
    }

    func makeEventItemViewModel(
        event: Event,
        today: DayIndex,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventItemViewModel {
        EventItemViewModel(
            event: event,
            today: today,
            hintEnabled: hintEnabled,
            commander: commander,
            renameHandler: WeakRef(renameHandler as? EventsListViewController),
            tapHandler: {
                self.parent.coordinator.show(.eventDetails(
                    factory: self.makeContainer(event: event, today: today)
                ))
            }
        )
    }

    func makeWidgetViewModel() -> [EventItemViewModel] {
        makeEventsListViewModel(nil)
            .items
            .filter { type(of: $0) is EventItemViewModel.Type }
            as! [EventItemViewModel]
    }

    func makeContainer(event: Event, today: DayIndex) -> EventDetailsContainer {
        EventDetailsContainer(
            parent: self,
            event: event,
            today: today
        )
    }
}
