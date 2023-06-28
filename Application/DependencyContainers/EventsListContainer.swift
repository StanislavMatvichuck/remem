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
    let orderingRepository = UserDefaultsEventsQuerySorterRepository()

    var uiTestingDisabled: Bool { parent.mode.uiTestingDisabled }

    init(parent: ApplicationContainer) {
        self.parent = parent
    }

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
        let today = DayIndex(parent.currentMoment)
        let ordering = uiTestingDisabled ? orderingRepository.get() : .alphabetical
        let events = parent.provider.get(using: ordering)

        let footerVm = makeFooterItemViewModel(
            eventsCount: events.count,
            handler: handler
        )

        let hintVm = makeHintItemViewModel(events: events)

        let orderingItems = EventsQuerySorter.allCases.map {
            OrderingCellItemViewModel(sorter: $0) { newSorter in
                let currentSorter = self.orderingRepository.get()

                if newSorter != currentSorter {
                    self.orderingRepository.set(current: newSorter)
                    self.updater.update()
                }
            }
        }

        let orderingVm = OrderingCellViewModel(
            items: orderingItems,
            selectedItemIndex: orderingItems.firstIndex { $0.hasSame(sorter: ordering) } ?? 0
        )

        let eventsViewModels = events.enumerated().map { index, event in
            let userShouldSeeGestureHint = hintVm.title == HintState.placeFirstMark.text
            let isFirstRow = index == 0
            let hintEnabled = userShouldSeeGestureHint && isFirstRow && uiTestingDisabled

            return makeEventItemViewModel(
                event: event,
                today: today,
                hintEnabled: hintEnabled,
                renameHandler: handler
            )
        }

        var items = [any EventsListItemViewModeling]()

        if uiTestingDisabled {
            items.append(hintVm)
            if events.count >= 2 { items.append(orderingVm) }
        }

        items.append(contentsOf: eventsViewModels)
        items.append(footerVm)

        let vm = EventsListViewModel(
            today: today,
            items: items
        ) { name in
            self.commander.save(Event(name: name))
        }

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
            currentMoment: parent.currentMoment,
            tapHandler: {
                self.parent.coordinator.show(.eventDetails(factory: self.makeContainer(
                    event: event,
                    today: today
                )))
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
