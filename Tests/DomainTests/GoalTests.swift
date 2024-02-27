//
//  GoalTests.swift
//  DomainTests
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Domain
import Foundation
import XCTest

final class GoalTests: XCTestCase {
    private var sut: Goal!
    
    override func setUp() {
        super.setUp()
        sut = Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: 0,
            event: Event.makeDefault()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init_requiresDateCreatedAndValueAndEvent() { XCTAssertNotNil(sut) }
    func test_progress_doesNotIncludeEventHappeningsBeforeDateCreated() {
        let event = Event.makeDefault()
        event.addHappening(date: DayIndex.referenceValue.date)
        sut = Goal(dateCreated: DayIndex.referenceValue.adding(days: 1).date, value: 1, event: event)
        
        XCTAssertEqual(sut.progress, 0)
    }
    
    func test_progress_countEventHappeningAfterDateCreated() {
        let event = Event.makeDefault()
        event.addHappening(date: DayIndex.referenceValue.adding(days: 1).date)
        sut = Goal(dateCreated: DayIndex.referenceValue.date, value: 1, event: event)
        
        XCTAssertEqual(sut.progress, 1.0)
        XCTAssertTrue(sut.achieved)
    }
    
    func test_progress_goalValueIsThreeAndTwoOfThreeEventHappeningsCounted() {
        let event = Event.makeDefault()
        event.addHappening(date: DayIndex.referenceValue.adding(days: 0).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 2).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 3).date)
        sut = Goal(dateCreated: DayIndex.referenceValue.adding(days: 1).date, value: 3, event: event)
        
        XCTAssertEqual(sut.progress, 2 / 3)
        XCTAssertFalse(sut.achieved)
    }
    
    func test_achievedAt_nil() { XCTAssertNil(sut.achievedAt) }
    func test_achievedAt_isFirstHappeningDateCreatedThatReachesProgressOfOne() {
        let event = Event.makeDefault()
        /// happening that is not counted
        event.addHappening(date: DayIndex.referenceValue.adding(days: 0).date)
        
        event.addHappening(date: DayIndex.referenceValue.adding(days: 2).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 3).date)
        
        let happeningDateCreatedThatMakesProgressOfOne = DayIndex.referenceValue.adding(days: 4).date
        event.addHappening(date: happeningDateCreatedThatMakesProgressOfOne)
        
        /// happening that makes progress more than one
        event.addHappening(date: DayIndex.referenceValue.adding(days: 5).date)
        
        sut = Goal(dateCreated: DayIndex.referenceValue.adding(days: 1).date, value: 3, event: event)
        
        XCTAssertEqual(sut.achievedAt, happeningDateCreatedThatMakesProgressOfOne)
    }
}

private extension Event {
    static func makeDefault() -> Event { Event(name: "", dateCreated: DayIndex.referenceValue.date) }
}
