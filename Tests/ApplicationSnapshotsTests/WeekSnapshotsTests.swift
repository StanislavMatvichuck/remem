//
//  WeekSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class WeekSnapshotsTest:
    FBSnapshotTestCase
{
    var sut: WeekViewController!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Week"
        arrange()
    }
    
    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }
    
    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByOneDay() {
        let offsetToday = DayComponents.referenceValue.adding(components: DateComponents(day: 1))
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetByOneDay() {
        let offsetDayCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 1))
        arrange(withDayCreated: offsetDayCreated, andToday: offsetDayCreated)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByTwoDaysAndDateCreatedOffsetByOneDay() {
        let offsetDayCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 1))
        let offsetToday = offsetDayCreated.adding(components: DateComponents(day: 1))
        arrange(withDayCreated: offsetDayCreated, andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetIs3_todayOffsetIs7() {
        let offsetDayCreated = DayComponents.referenceValue.adding(components: DateComponents(day: 3))
        let offsetToday = offsetDayCreated.adding(components: DateComponents(day: 4))
        arrange(withDayCreated: offsetDayCreated, andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset11() {
        let offsetToday = DayComponents.referenceValue.adding(components: DateComponents(day: 11))
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset1year() {
        let offsetToday = DayComponents.referenceValue.adding(components: DateComponents(year: 1))
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    private func arrange(
        withDayCreated: DayComponents = DayComponents.referenceValue,
        andToday: DayComponents = DayComponents.referenceValue
    ) {
        let root = ApplicationContainer(testingInMemoryMode: true)
        event = Event(name: "Event", dateCreated: withDayCreated.date)
        sut = root.makeWeekViewController(event: event, today: andToday)
        putInViewHierarchy(sut)
    }
}
