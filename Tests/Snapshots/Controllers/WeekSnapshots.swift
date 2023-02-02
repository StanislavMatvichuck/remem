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
    WeekViewControllerTesting
{
    var sut: WeekViewController!
    var event: Event!
    var viewModelFactory: WeekViewModelFactoring!
    
    override func setUp() {
        super.setUp()
        configureCommonOptions()
        arrange()
    }
    
    override func tearDown() {
        clearSutAndViewModelFactory()
        executeRunLoop()
        super.tearDown()
    }
    
    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByOneDay() {
        let offsetToday = DayIndex.referenceValue.adding(days: 1)
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetByOneDay() {
        let offsetDayCreated = DayIndex.referenceValue.adding(days: 1)
        arrange(withDayCreated: offsetDayCreated, andToday: offsetDayCreated)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_todayOffsetByTwoDaysAndDateCreatedOffsetByOneDay() {
        let offsetDayCreated = DayIndex.referenceValue.adding(days: 1)
        let offsetToday = offsetDayCreated.adding(days: 1)
        arrange(withDayCreated: offsetDayCreated, andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_dateCreatedOffsetIs3_todayOffsetIs7() {
        let offsetDayCreated = DayIndex.referenceValue.adding(days: 3)
        let offsetToday = offsetDayCreated.adding(days: 4)
        arrange(withDayCreated: offsetDayCreated, andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset11() {
        let offsetToday = DayIndex.referenceValue.adding(days: 11)
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_empty_createdOffset0_todayOffset1year() {
        let offsetToday = DayIndex.referenceValue.adding(days: 365)
        arrange(andToday: offsetToday)
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithHappenings_showsLabels() {
        addHappeningsAtEachMinute(minutes: 1, dayOffset: 0)
        addHappeningsAtEachMinute(minutes: 2, dayOffset: 1)
        addHappeningsAtEachMinute(minutes: 3, dayOffset: 2)
        addHappeningsAtEachMinute(minutes: 4, dayOffset: 3)
        addHappeningsAtEachMinute(minutes: 5, dayOffset: 4)
        addHappeningsAtEachMinute(minutes: 6, dayOffset: 5)
        addHappeningsAtEachMinute(minutes: 7, dayOffset: 6)
        
        sut.viewModel = viewModelFactory.makeViewModel()
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func test_eventWithHappenings_showsLabels_dark() { executeWithDarkMode(testCase: test_eventWithHappenings_showsLabels) }
    
    private func addHappeningsAtEachMinute(minutes: Int, dayOffset: Int) {
        for i in 0 ..< minutes {
            event.addHappening(date:
                DayIndex.referenceValue.adding(
                    dateComponents: DateComponents(day: dayOffset, minute: i)
                ).date
            )
        }
    }
    
    private func executeWithDarkMode(testCase: () -> Void) {
        sut.view.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        testCase()
    }
    
    private func arrange(
        withDayCreated: DayIndex = DayIndex.referenceValue,
        andToday: DayIndex = DayIndex.referenceValue
    ) {
        makeSutWithViewModelFactory(eventDateCreated: withDayCreated, today: andToday)
        putInViewHierarchy(sut)
    }
}
