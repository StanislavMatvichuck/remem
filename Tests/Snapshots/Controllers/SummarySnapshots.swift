//
//  StatsSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class SummarySnapshots: FBSnapshotTestCase, TestingViewController {    
    var sut: SummaryController!
    var commander: EventsCommanding!
    var event: Event!

    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        make()
        putInViewHierarchy(sut)
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_empty() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_empty_dark() { executeWithDarkMode(testCase: test_empty) }

    private func executeWithDarkMode(testCase: () -> Void) {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        testCase()
    }
}
