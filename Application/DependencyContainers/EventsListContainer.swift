//
//  EventsListContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2023.
//

import Domain
import UIKit

final class EventsListContainer:
    ControllerFactoring,
    EventsListViewModelFactoring,
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring
{
    let parent: ApplicationContainer
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var ordering: EventsQuerySorter = .alphabetical

    init(parent: ApplicationContainer) { self.parent = parent }

    func make() -> UIViewController {
        let view = EventsListView()
        let animator = DefaultHappeningCreationAnimator(table: view.table)
        let controller = EventsListViewController(
            viewModelFactory: self,
            view: view,
            widgetUpdater: WidgetViewController(),
            cellAnimator: animator
        )

        updater.addDelegate(controller)
        return controller
    }

    func makeEventsListViewModel(_ handler: EventsListViewModelHandling?) -> EventsListViewModel {
        let today = DayIndex(.now)
        let events = parent.provider.get(using: ordering)

        let footerVm = makeFooterItemViewModel(
            eventsCount: events.count,
            handler: handler
        )

        let hintVm = makeHintItemViewModel(events: events)

        let orderingItems = EventsQuerySorter.allCases.map {
            OrderingCellItemViewModel(sorter: $0) { sorter in
                self.ordering = sorter
                self.updater.update()
            }
        }
        let orderingVm = OrderingCellViewModel(items: orderingItems)

        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text // make this for first row only

        let eventsViewModels = events.enumerated().map { index, event in
            makeEventItemViewModel(
                event: event,
                today: today,
                hintEnabled: gestureHintEnabled && index == 0,
                renameHandler: handler
            )
        }

        var items = [any EventsListItemViewModeling]()
        items.append(hintVm)
        if events.count >= 2 { items.append(orderingVm) }
        items.append(contentsOf: eventsViewModels)
        items.append(footerVm)

        let vm = EventsListViewModel(
            today: today,
            commander: commander,
            items: items
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
        today: DayIndex,
        hintEnabled: Bool,
        renameHandler: EventItemViewModelRenameHandling?
    ) -> EventCellViewModel {
        EventCellViewModel(
            event: event,
            hintEnabled: hintEnabled,
            today: today,
            tapHandler: {
                self.parent.coordinator.show(.eventDetails(factory: self.makeContainer(
                    event: event,
                    today: today
                )))
            },
            swipeHandler: {
                event.addHappening(date: .now)
                self.commander.save(event)
            },
            renameActionHandler: { renameHandler?.renameTapped($0) },
            deleteActionHandler: { self.commander.delete(event) },
            renameHandler: { newName, event in
                event.name = newName
                self.commander.save(event)
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
