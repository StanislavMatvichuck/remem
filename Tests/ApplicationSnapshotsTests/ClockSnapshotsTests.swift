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
        sut.view.window?.overrideUserInterfaceStyle = .dark

        FBSnapshotVerifyViewController(sut)
    }
}
