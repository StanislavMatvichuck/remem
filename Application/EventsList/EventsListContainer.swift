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
    EventCellViewModelFactoring,
    FooterItemViewModeFactoring
{
    let parent: ApplicationContainer
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }

    var uiTestingDisabled: Bool { parent.mode.uiTestingDisabled }

    init(_ parent: ApplicationContainer) { self.parent = parent }

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
        let events = parent.provider.get()

        let footerVm = makeFooterItemViewModel(
            eventsCount: events.count,
            handler: handler
        )

        let hintVm = makeHintItemViewModel(events: events)

        let eventsViewModels = events.enumerated().map { index, event in
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

        let vm = EventsListViewModel(cells: cells) { name in
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
}
