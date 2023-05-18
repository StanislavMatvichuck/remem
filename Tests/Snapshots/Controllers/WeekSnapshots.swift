//
//  WeekSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class WeekSnapshots:
    FBSnapshotTestCase,
    TestingViewController
{
    var sut: WeekViewController!
    var commander: EventsCommanding!
    var event: Event!
    
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
    }
    
    override func tearDown() {
        clear()
        super.tearDown()
    }
    
    func test_empty() {
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByOneDay() {
        make(today: DayIndex.referenceValue.adding(days: 1))
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetByOneDay() {
        let day = DayIndex.referenceValue.adding(days: 1)
        make(created: day, today: day)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByTwoDaysAndDateCreatedOffsetByOneDay() {
        make(
            created: DayIndex.referenceValue.adding(days: 1),
            today: DayIndex.referenceValue.adding(days: 1).adding(days: 1)
        )
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetIs3_todayOffsetIs7() {
        make(
            created: DayIndex.referenceValue.adding(days: 3),
            today: DayIndex.referenceValue.adding(days: 3).adding(days: 4)
        )
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset11() {
        make(today: DayIndex.referenceValue.adding(days: 11))
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset1year() {
        make(today: DayIndex.referenceValue.adding(days: 365))
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithHappenings_showsLabels() {
        make() // executed after dark mode handling
        
        addHappeningsAtEachMinute(minutes: 1, dayOffset: 0)
        addHappeningsAtEachMinute(minutes: 2, dayOffset: 1)
        addHappeningsAtEachMinute(minutes: 3, dayOffset: 2)
        addHappeningsAtEachMinute(minutes: 4, dayOffset: 3)
        addHappeningsAtEachMinute(minutes: 5, dayOffset: 4)
        addHappeningsAtEachMinute(minutes: 6, dayOffset: 5)
        addHappeningsAtEachMinute(minutes: 7, dayOffset: 6)
        
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithHappenings_showsLabels_dark() {
        make() // executed after dark mode handling
        
        addHappeningsAtEachMinute(minutes: 1, dayOffset: 0)
        addHappeningsAtEachMinute(minutes: 2, dayOffset: 1)
        addHappeningsAtEachMinute(minutes: 3, dayOffset: 2)
        addHappeningsAtEachMinute(minutes: 4, dayOffset: 3)
        addHappeningsAtEachMinute(minutes: 5, dayOffset: 4)
        addHappeningsAtEachMinute(minutes: 6, dayOffset: 5)
        addHappeningsAtEachMinute(minutes: 7, dayOffset: 6)
        
        sendEventUpdatesToController()
        
        sut.view.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        executeRunLoop()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithGoal() {
        make()
        event.setWeeklyGoal(amount: 1, for: DayIndex.referenceValue.date)
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithTwoGoals_secondGoalAddedAfterAWeek() {
        let dateCreated = DayIndex.referenceValue
        let today = dateCreated.adding(days: 7)
        
        make(
            created: dateCreated,
            today: today
        )
        
        event.setWeeklyGoal(amount: 1, for: dateCreated.date)
        event.setWeeklyGoal(amount: 2, for: today.date)
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    private func addHappeningsAtEachMinute(minutes: Int, dayOffset: Int) {
        for i in 0 ..< minutes {
            event.addHappening(date:
                DayIndex.referenceValue.adding(
                    dateComponents: DateComponents(day: dayOffset, minute: i)
                ).date
            )
        }
    }
    
    private func make(
        created: DayIndex = DayIndex.referenceValue,
        today: DayIndex = DayIndex.referenceValue
    ) {
        // make as regular and perform updates here?
        event = Event(name: "Event", dateCreated: created.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = WeekContainer(parent: container).make() as! WeekViewController
        putInViewHierarchy(sut)
    }
}
