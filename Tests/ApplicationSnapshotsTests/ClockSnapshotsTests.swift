//
//  ClockSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

class ClockSnapshotsTest: FBSnapshotTestCase {
    var sut: ClockController!

    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Clock"
        sut = ClockController.make(event: Event(name: "Event"))
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

    func test_emptyDark() {
        configureDarkMode()

        FBSnapshotVerifyViewController(sut)
    }

    func test_singleHappening() {
        sut.forceViewToLayoutInScreenSize()

        sut.addOneHappening(at: TimeComponents(h: 12, m: 1, s: 1))

        FBSnapshotVerifyViewController(sut)
    }

    func test_singleHappeningDark() {
        sut.forceViewToLayoutInScreenSize()

        sut.addOneHappening(at: TimeComponents(h: 12, m: 1, s: 1))

        configureDarkMode()

        FBSnapshotVerifyViewController(sut)
    }

    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
    }
}
