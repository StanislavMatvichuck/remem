//
//  Fakes.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.03.2023.
//

@testable import Application
import Domain

struct VisitedEventListFactory: EventsListViewModelFactoring {
    let event: Event = {
        let event = Event(name: "VisitedEvent", dateCreated: DayIndex.referenceValue.date)
        event.visit()
        event.addHappening(date: DayIndex.referenceValue.date)
        return event
    }()

    let commander = EventsCommandingStub()
    let today = DayIndex.referenceValue

    func makeEventsListViewModel(_: EventsListViewModelHandling?) -> EventsListViewModel {
        EventsListViewModel(
            today: today,
            items: [
                HintCellViewModel(events: [event]),
                EventCellViewModel(
                    event: event,
                    hintEnabled: false,
                    today: today,
                    currentMoment: DayIndex.referenceValue.date,
                    tapHandler: {},
                    swipeHandler: {},
                    renameActionHandler: { _ in },
                    deleteActionHandler: {},
                    renameHandler: { _, _ in }
                ),
                FooterCellViewModel(eventsCount: 1, tapHandler: nil),
            ]
        ) { _ in }
    }
}
