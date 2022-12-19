//
//  DayDetailsViewModelTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

class DayViewModelTests: XCTestCase {
    func test_eventWithNoHappenings_showsNothing() {
        let sut = make()

        XCTAssertEqual(sut.items.count, 0)
    }

    func test_eventWithHappeningAtSameDay_showsHappening() {
        let happening = Happening(dateCreated: DayComponents.referenceValue.date)
        let sut = make(happenings: [happening])

        XCTAssertEqual(sut.items.count, 1)
    }

    func test_eventWithHappeningAtAnotherDay_showsNothing() {
        let date = DayComponents.referenceValue.adding(components: DateComponents(day: 1)).date
        let happening = Happening(dateCreated: date)
        let sut = make(happenings: [happening])

        XCTAssertEqual(sut.items.count, 0)
    }

    private func make(happenings: [Happening] = []) -> DayViewModel {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        for happening in happenings {
            event.addHappening(date: happening.dateCreated)
        }
        let commander = EventsRepositoryFake(events: [event])
        let sut = DayViewModel(
            day: day,
            event: event,
            commander: commander,
            factory: DayItemViewModelFactory(commander: commander)
        )
        return sut
    }
}
