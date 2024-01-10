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

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_eventWithHappeningAtSameDay_showsHappening() {
        let happening = Happening(dateCreated: DayIndex.referenceValue.date)
        let sut = make(happenings: [happening])

        XCTAssertEqual(sut.cellsCount, 1)
    }

    func test_eventWithHappeningAtAnotherDay_showsNothing() {
        let date = DayIndex.referenceValue.adding(dateComponents: DateComponents(day: 1)).date
        let happening = Happening(dateCreated: date)
        let sut = make(happenings: [happening])

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_cellsCount_empty_zero() {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let sut = DayDetailsContainer(EventDetailsContainer(appC, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_cellsCount_oneHappening_one() {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        let sut = DayDetailsContainer(EventDetailsContainer(appC, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()

        XCTAssertEqual(sut.cellsCount, 1)
    }

    func test_cellAtIndex_firstCell() {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        let sut = DayDetailsContainer(EventDetailsContainer(appC, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()

        XCTAssertEqual(sut.cellAt(index: 0).text, "00:00")
    }

    private func make(happenings: [Happening] = []) -> DayDetailsViewModel {
        let day = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        for happening in happenings {
            event.addHappening(date: happening.dateCreated)
        }

        struct DayItemViewModelFactoringStub: DayCellViewModelFactoring {
            let event: Event
            let commander = EventsCommandingStub()

            func makeViewModel(happening: Happening) -> DayCellViewModel {
                DayCellViewModel(happening: happening) { _ in }
            }
        }

        return DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date,
            event: event,
            startOfDay: DayIndex.referenceValue.date,
            factory: DayItemViewModelFactoringStub(event: event),
            addHappeningHandler: { _ in }
        )
    }
}
