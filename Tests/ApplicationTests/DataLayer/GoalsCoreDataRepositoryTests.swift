//
//  GoalsCoreDataRepositoryTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import DataLayer
// @testable import Application
import Domain
import XCTest

final class GoalsCoreDataRepositoryTests: XCTestCase {
    private var sut: GoalsCoreDataRepository!
    private var event: Event!
    private var eventsRepository: CoreDataEventsRepository!
    
    override func setUp() {
        super.setUp()
        let container = CoreDataStack.createContainer(inMemory: true)
        let event = Event(name: "", dateCreated: .distantPast)
        let eventsRepository = CoreDataEventsRepository(container: container)
        eventsRepository.create(event: event)
        sut = GoalsCoreDataRepository(container: container)
        self.event = event
        self.eventsRepository = eventsRepository
    }
    
    override func tearDown() { super.tearDown(); sut = nil; event = nil; eventsRepository = nil }
    
    func test_init() { XCTAssertNotNil(sut) }
    
    func test_create() {
        XCTAssertEqual(sut.read(forEvent: event).count, 0)
        
        sut.create(goal: Goal(dateCreated: .distantPast, event: event))
        
        XCTAssertEqual(sut.read(forEvent: event).count, 1)
    }
    
    func test_update() {
        let goal = Goal(dateCreated: .distantPast, event: event)
        
        sut.create(goal: goal)
        
        goal.update(value: 2)
        
        sut.update(id: goal.id, goal: goal)
        
        XCTAssertEqual(sut.read(forEvent: event).first!.value, goal.value)
    }
    
    func test_delete() {
        let goal = Goal(dateCreated: .distantPast, event: event)
        sut.create(goal: goal)
        
        XCTAssertEqual(sut.read(forEvent: event).first!.id, goal.id)
        
        sut.delete(id: goal.id)
        
        XCTAssertEqual(sut.read(forEvent: event).count, 0)
    }
    
    func test_deletingEvent_removesRelatedGoals() {
        let goal = Goal(dateCreated: .distantPast, event: event)
        
        sut.create(goal: goal)
     
        XCTAssertEqual(sut.read(forEvent: event).first!.id, goal.id)
        
        eventsRepository.delete(id: event.id)
        
        XCTAssertEqual(sut.read(forEvent: event).count, 0)
    }
}
