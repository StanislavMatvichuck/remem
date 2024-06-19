//
//  WeekCircleViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 18.06.2024.
//

@testable import Application
import DataLayer
import Domain
import XCTest

final class WeekCircleViewModelTests: XCTestCase {
    // MARK: - Tests

    func test_init_requiresEventsReadingAndEventId() {
        let sut = makeWithoutEvent()

        XCTAssertNotNil(sut)
    }

    func test_conformsToCircularViewModeling() {
        let sut = makeWithoutEvent()

        XCTAssertNotNil(sut as CircularViewModeling)
    }

    func test_vertices_count_seven() {
        let sut = makeWithoutEvent()

        XCTAssertEqual(sut.vertices.count, 7)
    }

    func test_vertices_first_text_localizedDayOfWeek() {
        let sut = makeWithoutEvent()

        XCTAssertEqual(sut.vertices.first?.text, "Mon")
    }

    func test_vertices_withoutHappenings_value_zero() {
        let sut = makeWithoutEvent()

        for index in 0 ..< sut.vertices.count {
            XCTAssertEqual(sut.vertices[index].value, 0)
        }
    }

    func test_vertices_happeningAtMonday_first_valueOne() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
        ])

        XCTAssertEqual(sut.vertices.first?.value, 1.0)
    }

    func test_vertices_happeningsAtEachDay_valueOne_forAll() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 1).date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 2).date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 3).date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 4).date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 5).date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 6).date),
        ])

        XCTAssertEqual(sut.vertices[0].value, 1.0)
        XCTAssertEqual(sut.vertices[1].value, 1.0)
        XCTAssertEqual(sut.vertices[2].value, 1.0)
        XCTAssertEqual(sut.vertices[3].value, 1.0)
        XCTAssertEqual(sut.vertices[4].value, 1.0)
        XCTAssertEqual(sut.vertices[5].value, 1.0)
        XCTAssertEqual(sut.vertices[6].value, 1.0)
    }

    func test_vertices_threeHappeningsAtMonday_valueOneAtMondayOnly() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
        ])

        XCTAssertEqual(sut.vertices[0].value, 1.0)
        XCTAssertEqual(sut.vertices[1].value, 0)
        XCTAssertEqual(sut.vertices[2].value, 0)
        XCTAssertEqual(sut.vertices[3].value, 0)
        XCTAssertEqual(sut.vertices[4].value, 0)
        XCTAssertEqual(sut.vertices[5].value, 0)
        XCTAssertEqual(sut.vertices[6].value, 0)
    }

    func test_vertices_twoHappeningsAtMondayAndOneAtTuesday_valuesMonday100Tuesday50() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.adding(days: 1).date),
        ])

        XCTAssertEqual(sut.vertices[0].value, 1.0)
        XCTAssertEqual(sut.vertices[1].value, 0.5)
    }

    // MARK: - Private

    private func makeWithoutEvent() -> WeekCircleViewModel { WeekCircleViewModel(reader: EventsReaderStub(), eventId: "") }
    private func makeWith(happenings: [Happening]) -> WeekCircleViewModel {
        let event = Event(id: UUID().uuidString, name: "", happenings: happenings, dateCreated: .distantPast, dateVisited: nil)
        let reader = CoreDataEventsRepository(container: CoreDataStack.createContainer(inMemory: true))
        reader.create(event: event)
        return WeekCircleViewModel(reader: reader, eventId: event.id)
    }
}
