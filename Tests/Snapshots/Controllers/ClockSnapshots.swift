//
//  ClockSnapshotsTests.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class ClockSnapshots:
    FBSnapshotTestCase,
    TestingViewController
{
    var sut: ClockViewController!
    var event: Event!
    var commander: EventsCommanding!

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
        verify()
    }

    func test_emptyDark() {
        configureDarkMode()

        verify()
    }

    func test_singleHappening() {
        arrangeSingleHappening()

        verify()
    }

    func test_singleHappeningDark() {
        arrangeSingleHappening()
        configureDarkMode()

        verify()
    }

    func test_manyHappenings() {
        addOneHappening(at: TimeComponents(h: 0, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 0, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 3, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 6, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 6, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 9, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 12, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 18, m: 0, s: 0))
        addOneHappening(at: TimeComponents(h: 18, m: 0, s: 0))
        sendEventUpdatesToController()

        verify()
    }

    private func verify() {
        let screenWidth = UIScreen.main.bounds.width
        sut.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        FBSnapshotVerifyView(sut.view)
    }

    private func arrangeSingleHappening() {
        addOneHappening(at: TimeComponents(h: 0, m: 0, s: 0))
        sendEventUpdatesToController()
    }

    private func configureDarkMode() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
    }
}
