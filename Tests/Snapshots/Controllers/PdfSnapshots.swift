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
        configureSnapshotsOptions()
        recordMode = true
        make()
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_referenceDate() {
        verify()
    }

    func test_referenceDate_dark() {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
        verify()
    }

    func test_referenceDate02() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 7))

        verify()
    }

    func test_referenceDate03() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 2 * 7))

        verify()
    }

    func test_referenceDate04() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 3 * 7))

        verify()
    }

    func test_referenceDate05() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 4 * 7))

        verify()
    }

    func test_referenceDate06() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 5 * 7))

        verify()
    }

    func test_referenceDate07() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 6 * 7))

        verify()
    }

    func test_referenceDate08() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 7 * 7))

        verify()
    }

    func test_referenceDate09() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 8 * 7))

        verify()
    }

    func test_referenceDate30_firstPage() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 30 * 7))

        verify()
    }

    /// This test fails
    func test_referenceDate30_secondPage() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 30 * 7))

        sut.viewRoot.scrollTo(page: 1)

        verify()
    }

    private func verify(
        file: StaticString = #file,
        line: UInt = #line
    ) {
        sut.viewRoot.layoutIfNeeded()
        FBSnapshotVerifyView(sut.viewRoot)
    }
}
