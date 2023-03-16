//
//  PdfSnapshots.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 16.03.2023.
//

@testable import Application
import Domain
import iOSSnapshotTestCase

final class PdfSnapshots:
    FBSnapshotTestCase,
    TestingViewController
{
    var sut: PdfViewController!
    var event: Event!

    override func setUp() {
        super.setUp()
        configureCommonOptions()
        make()
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_referenceDate() {
        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate_dark() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        executeRunLoop()
        FBSnapshotVerifyViewController(sut)
    }
}
