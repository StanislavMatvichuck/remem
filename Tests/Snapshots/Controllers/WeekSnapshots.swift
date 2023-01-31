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
        recordMode = true
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
                DayComponents.referenceValue.adding(
                    components: DateComponents(day: dayOffset, minute: i)
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
        withDayCreated: DayComponents = DayComponents.referenceValue,
        andToday: DayComponents = DayComponents.referenceValue
    ) {
        makeSutWithViewModelFactory(eventDateCreated: withDayCreated, today: andToday)
        putInViewHierarchy(sut)
    }
}
