////
////  GoalCoreDataMapperTests.swift
////  ApplicationTests
////
////  Created by Stanislav Matvichuck on 16.04.2024.
////
//
//import CoreData
//import DataLayer
//import Domain
//import XCTest
//
//final class GoalCoreDataMapperTests: XCTestCase {
//    private var sut: GoalCoreDataMapper!
//
//    override func setUp() { super.setUp() }
//    override func tearDown() { super.tearDown(); sut = nil }
//
//    func test_bidirectionalConversion() {
//        let date = DayIndex.referenceValue.date
//        let event = Event(
//            id: UUID().uuidString,
//            name: "Event",
//            happenings: [],
//            dateCreated: date,
//            dateVisited: nil
//        )
//
//        var goal = Goal(dateCreated: date, event: event)
//
//        assertBidirectionalConversion(goal: goal)
//
//        event.addHappening(date: date)
//        goal.update(value: 3)
//
//        assertBidirectionalConversion(goal: goal)
//    }
//
//    private func assertBidirectionalConversion(goal: Goal, file: StaticString = #file, line: UInt = #line) {
//        let context = CoreDataStack.createContainer(inMemory: true).viewContext
//        let cdGoal = CDGoal(context: context)
//        // cdEvent must be created in the context prior to goal
//        let cdEvent = CDEvent(context: context)
//        let eventMapper = EventEntityMapper()
//        eventMapper.update(cdEvent, by: goal.event)
//
//        sut = GoalCoreDataMapper(cdEvent: cdEvent)
//
//        sut.update(cdGoal, by: goal)
//
//        let recreatedGoal = sut.convert(cdGoal)
//
//        XCTAssertEqual(goal, recreatedGoal)
//    }
//}
//
//extension Goal: Equatable {
//    public static func == (lhs: Domain.Goal, rhs: Domain.Goal) -> Bool {
//        lhs.id == rhs.id &&
//            lhs.event.id == rhs.event.id &&
//            lhs.value == rhs.value &&
//            lhs.dateCreated == rhs.dateCreated
//    }
//}
