//
//  DayDetailsViewModelTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

final class DayDetailsViewModelTests: XCTestCase {
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

    private func make(happenings: [Happening] = []) -> DayDetailsViewModel {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        for happening in happenings {
            event.addHappening(date: happening.dateCreated)
        }

        struct DayItemViewModelFactoringStub: DayItemViewModelFactoring {
            let event: Event
            let commander = EventsCommandingStub()

            func makeViewModel(happening: Happening) -> DayItemViewModel {
                DayItemViewModel(event: event, happening: happening, commander: commander)
            }
        }

        return DayDetailsViewModel(
            day: day,
            event: event,
            commander: EventsCommandingStub(),
            itemFactory: DayItemViewModelFactoringStub(event: event)
        )
    }
}
