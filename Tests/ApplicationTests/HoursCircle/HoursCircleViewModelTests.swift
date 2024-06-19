//
//  HoursCircleViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

@testable import Application
import DataLayer
import Domain
import Foundation
import XCTest

final class HoursCircleViewModelTests: XCTestCase {
    func test_init_requiresEventsReadingAndEventId() {
        let sut = makeWithoutEvent()
        
        XCTAssertNotNil(sut)
    }
    
    func test_conformsToCircularViewModeling() {
        let sut = makeWithoutEvent()
        
        XCTAssertNotNil(sut as CircularViewModeling)
    }
    
    func test_vertices_count_twentyFour() {
        let sut = makeWithoutEvent()
        
        XCTAssertEqual(sut.vertices.count, 24)
    }
    
    func test_vertices_first_text_0() {
        let sut = makeWithoutEvent()
        
        XCTAssertEqual(sut.vertices.first?.text, "0")
    }
    
    func test_vertices_last_text_23() {
        let sut = makeWithoutEvent()
        
        XCTAssertEqual(sut.vertices.last?.text, "23")
    }
    
    func test_vertices_withoutHappenings_value_zero() {
        let sut = makeWithoutEvent()
        
        for index in 0 ..< sut.vertices.count {
            XCTAssertEqual(sut.vertices[index].value, 0)
        }
    }
    
    func test_vertices_first_oneHappening_value_one() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date)
        ])
        
        XCTAssertEqual(sut.vertices.first?.value, 1)
        
        for index in 1 ..< sut.vertices.count {
            XCTAssertEqual(sut.vertices[index].value, 0)
        }
    }
    
    func test_vertices_last_oneHappening_value_one() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date.addingTimeInterval(TimeInterval(60 * 60 * 23)))
        ])
        
        XCTAssertEqual(sut.vertices.last?.value, 1)
        
        for index in 0 ..< sut.vertices.count - 1 {
            XCTAssertEqual(sut.vertices[index].value, 0)
        }
    }
    
    func test_vertices_happeningEachHour_allValues_one() {
        var happenings = [Happening]()
        
        for hour in 0 ..< 24 {
            happenings.append(Happening(dateCreated: DayIndex.referenceValue.date.addingTimeInterval(TimeInterval(60 * 60 * hour))))
        }
        
        let sut = makeWith(happenings: happenings)
        
        for index in 0 ..< sut.vertices.count {
            XCTAssertEqual(sut.vertices[index].value, 1)
        }
    }
    
    func test_vertices_twoHappeningsAtFirstHour_oneHappeningAtSecond_values() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date.addingTimeInterval(TimeInterval(60 * 60)))
        ])
        
        XCTAssertEqual(sut.vertices[0].value, 1)
        XCTAssertEqual(sut.vertices[1].value, 0.5)
    }
    
    func test_vertices_threeHappeningsAtFirstHour_oneHappeningAtSecond_values() {
        let sut = makeWith(happenings: [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date.addingTimeInterval(TimeInterval(60 * 60)))
        ])
        
        XCTAssertEqual(sut.vertices[0].value, 1)
        XCTAssertEqual(sut.vertices[1].value, 1 / 3)
    }
    
    // MARK: - Private
    
    private func makeWithoutEvent() -> HoursCircleViewModel { HoursCircleViewModel(reader: EventsReaderStub(), eventId: "") }
    private func makeWith(happenings: [Happening]) -> HoursCircleViewModel {
        let event = Event(id: UUID().uuidString, name: "", happenings: happenings, dateCreated: .distantPast, dateVisited: nil)
        let reader = CoreDataEventsRepository(container: CoreDataStack.createContainer(inMemory: true))
        reader.create(event: event)
        return HoursCircleViewModel(reader: reader, eventId: event.id)
    }
}
