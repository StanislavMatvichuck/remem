//
//  StatsSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class SummarySnapshots: FBSnapshotTestCase {
    var sut: SummaryViewController!
//    var event: Event!
//    var viewModelFactory: WeekViewModelFactoring!

    override func setUp() {
        super.setUp()
        configureCommonOptions()
        let event = Event(name: "Event")
        let viewModel = SummaryViewModel(event: event, today: DayIndex(date: .now))
        sut = SummaryViewController(viewModel: viewModel)
        putInViewHierarchy(sut)
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_empty_dark() { executeWithDarkMode(testCase: test_empty) }

    private func executeWithDarkMode(testCase: () -> Void) {
        sut.view.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        testCase()
    }
}
