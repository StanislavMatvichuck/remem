//
//  WeekSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class WeekSnapshotsTest: FBSnapshotTestCase {
    var sut: WeekViewController!
    
    override func setUp() {
        super.setUp()
        recordMode = true
        folderName = "Week"
        
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }
    
    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByOneDay() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue
        let today = dateCreated.adding(components: DateComponents(day: 1))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetByOneDay() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 1))
        let today = dateCreated.adding(components: DateComponents(day: 0))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByTwoDaysAndDateCreatedOffsetByOneDay() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 1))
        let today = dateCreated.adding(components: DateComponents(day: 1))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetIsWeekAndDateCreatedOffsetIs3() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 3))
        let today = dateCreated.adding(components: DateComponents(day: 4))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        event.addHappening(date: dateCreated.date.addingTimeInterval(61))
        
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset11() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 0))
        let today = dateCreated.adding(components: DateComponents(day: 11))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset1year() {
        let coordinator = ApplicationFactory().makeCoordinator()
        let useCase = EventEditUseCasingFake()
        let dateCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 0))
        let today = dateCreated.adding(components: DateComponents(year: 1))
        let event = Event(name: "Event", dateCreated: dateCreated.date)
        
        sut = WeekViewController(
            today: today,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )
        
        putInViewHierarchy(sut)
        
        FBSnapshotVerifyViewController(sut)
    }
}
