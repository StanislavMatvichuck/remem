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
    TestingViewController,
    MakingSnapshotsRowView
{
    // MARK: - Setup
    var sut: WeekViewController!
    var commander: EventsCommanding!
    var event: Event!
    
    var dayCreated = DayIndex.referenceValue
    var today = DayIndex.referenceValue
    
    func make() {
        event = Event(name: "Event", dateCreated: dayCreated.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = WeekContainer(parent: container).make() as! WeekViewController
        putInViewHierarchy(sut)
    }
    
    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        recordMode = true
    }
    
    override func tearDown() {
        clear()
        super.tearDown()
    }
    
    // MARK: - Test cases
    func test_empty() {
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByOneDay() {
        today = DayIndex.referenceValue.adding(days: 1)
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetByOneDay() {
        dayCreated = DayIndex.referenceValue.adding(days: 1)
        today = dayCreated
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByTwoDaysAndDateCreatedOffsetByOneDay() {
        dayCreated = DayIndex.referenceValue.adding(days: 1)
        today = dayCreated.adding(days: 1)
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetIs3_todayOffsetIs7() {
        dayCreated = DayIndex.referenceValue.adding(days: 3)
        today = dayCreated.adding(days: 4)
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset11() {
        today = DayIndex.referenceValue.adding(days: 11)
        make()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset1year() {
        today = DayIndex.referenceValue.adding(days: 365)
        make()
        
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
        dayCreated = DayIndex.referenceValue
        today = dayCreated.adding(days: 7)
        make()
        
        event.setWeeklyGoal(amount: 1, for: dayCreated.date)
        event.setWeeklyGoal(amount: 2, for: today.date)
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_currentWeek_withoutGoal() {
        arrangeTwoWeeks()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_currentWeek_goalSet_amountIsZero() {
        arrangeTwoWeeks()
        
        event.setWeeklyGoal(amount: 12, for: today.date)
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_currentWeek_goalSet_amountIsNotZero() {
        arrangeTwoWeeks()
        
        event.setWeeklyGoal(amount: 12, for: today.date)
        event.addHappening(date: today.date)
        event.addHappening(date: today.date.addingTimeInterval(60))
        event.addHappening(date: today.date.addingTimeInterval(60 * 60))
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_currentWeek_goalSet_goalAchieved() {
        arrangeTwoWeeks()
        
        event.setWeeklyGoal(amount: 12, for: today.date)
        
        for _ in 0 ..< 12 { event.addHappening(date: today.date) }
        
        sendEventUpdatesToController()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_pastWeek_withoutGoal() {
        arrangeTwoWeeks()
        
        sut.viewModel.timelineVisibleIndex = 0
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_pastWeek_goalSet_amountIsZero() {
        arrangeTwoWeeks()
        
        event.setWeeklyGoal(amount: 12, for: dayCreated.date)
        sendEventUpdatesToController()
        
        sut.viewModel.timelineVisibleIndex = 0
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_pastWeek_goalSet_amountIsNotZero() {
        arrangeTwoWeeks()
        
        event.setWeeklyGoal(amount: 12, for: dayCreated.date)
        event.addHappening(date: dayCreated.adding(days: 1).date)
        event.addHappening(date: dayCreated.adding(days: 2).date)
        event.addHappening(date: dayCreated.adding(days: 3).date)
        sendEventUpdatesToController()
        
        sut.viewModel.timelineVisibleIndex = 0
        
        FBSnapshotVerifyViewController(sut)
    }
    
    var height: CGFloat { .layoutSquare * 6 }
    
    func test_weekGoalStateAtlas() {
        let atlas = make([
            "Week/test_pastWeek_withoutGoal",
            "Week/test_currentWeek_withoutGoal",
            "Week/test_currentWeek_goalSet_amountIsZero",
            "Week/test_currentWeek_goalSet_amountIsNotZero",
            "Week/test_currentWeek_goalSet_goalAchieved",
            "Week/test_pastWeek_goalSet_amountIsZero",
            "Week/test_pastWeek_goalSet_amountIsNotZero",
        ])
        
        FBSnapshotVerifyView(atlas)
    }
    
    // MARK: - Private
    private func addHappeningsAtEachMinute(minutes: Int, dayOffset: Int) {
        for i in 0 ..< minutes {
            event.addHappening(date:
                DayIndex.referenceValue.adding(
                    dateComponents: DateComponents(day: dayOffset, minute: i)
                ).date
            )
        }
    }
    
    private func arrangeTwoWeeks() {
        dayCreated = DayIndex.referenceValue.adding(days: 1)
        today = dayCreated.adding(days: 9)
        make()
    }
}
