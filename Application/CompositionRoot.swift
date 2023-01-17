//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

class CompositionRoot:
    CoordinatingFactoring,
    ClockViewModelFactoring,
    DayViewModelFactoring,
    DayItemViewModelFactoring,
    EventViewModelFactoring,
    EventsListViewModelFactoring,
    HintItemViewModelFactoring,
    EventItemViewModelFactoring,
    FooterItemViewModeFactoring,
    WeekViewModelFactoring,
    WeekItemViewModelFactoring
{
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinating

    let eventsListViewModelUpdater: EventsListUpdater
    let dayViewModelUpdater: DayUpdater
    let clockViewModelUpdater: ClockUpdater
    let weekViewModelUpdater: WeekUpdater

    init(testingInMemoryMode: Bool = false) {
        let coordinator = DefaultCoordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: testingInMemoryMode),
            mapper: EventEntityMapper()
        )

        let eventsListUpdater = EventsListUpdater(
            decorated: repository,
            eventsProvider: repository
        )

        let dayUpdater = DayUpdater(eventsListUpdater)
        let clockUpdater = ClockUpdater(dayUpdater)
        let weekUpdater = WeekUpdater(clockUpdater)

        self.eventsListViewModelUpdater = eventsListUpdater
        self.dayViewModelUpdater = dayUpdater
        self.clockViewModelUpdater = clockUpdater
        self.weekViewModelUpdater = weekUpdater

        self.coordinator = coordinator
        self.provider = repository
        self.commander = weekUpdater

        coordinator.factory = self
        eventsListUpdater.factory = self
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(.list)
        return coordinator.root
    }

    // MARK: - Controllers creation
    func makeController(for navCase: CoordinatingCase) -> UIViewController {
        switch navCase {
        case .list: return makeEventsListViewController(events: provider.get())
        case .eventItem(let today, let event): return makeEventViewController(event, today)
        case .weekItem(let day, let event): return makeDayViewController(event, day)
        }
    }

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
        eventsListViewModelUpdater.add(receiver: controller)
        return controller
    }

    func makeEventViewController(_ event: Domain.Event, _ today: DayComponents) -> EventViewController {
        EventViewController(
            viewModel: makeEventViewModel(event: event),
            controllers: [
                makeWeekViewController(
                    event: event,
                    today: today
                ),
                makeClockViewController(event: event),
            ]
        )
    }

    func makeWeekViewController(event: Event, today: DayComponents) -> WeekViewController {
        let controller = WeekViewController(viewModel: makeWeekViewModel(event: event, today: today))
        weekViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    func makeClockViewController(event: Event) -> ClockViewController {
        let controller = ClockViewController(viewModel: makeClockViewModel(event: event))
        clockViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    func makeDayViewController(_ event: Event, _ day: DayComponents) -> DayViewController {
        let viewModel = makeDayViewModel(event: event, day: day)
        let controller = DayViewController(viewModel: viewModel)
        dayViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    // MARK: - ViewModels creation
    func makeEventsListViewModel(events: [Event]) -> EventsListViewModel {
        let today = DayComponents(date: .now)
        let footerVm = makeFooterItemViewModel(eventsCount: events.count)
        let hintVm = makeHintItemViewModel(events: events)
        let gestureHintEnabled = hintVm.title == HintState.placeFirstMark.text

        let vm = EventsListViewModel(
            events: events,
            today: today,
            commander: commander,
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
            ],
            selfFactory: self
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
            coordinator: coordinator,
            commander: commander
        )
    }

    func makeClockViewModel(event: Event) -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144),
            selfFactory: self
        )
    }

    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(
            day: day,
            event: event,
            commander: commander,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeEventViewModel(event: Event) -> EventViewModel {
        EventViewModel(
            event: event,
            commander: commander,
            selfFactory: self
        )
    }

    func makeDayItemViewModel(event: Event, happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: commander
        )
    }

    func makeWeekViewModel(event: Event, today: DayComponents) -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: coordinator,
            commander: commander,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeWeekItemViewModel(event: Event, today: DayComponents, day: DayComponents) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: coordinator
        )
    }
}
