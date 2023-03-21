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
        recordMode = true
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

    func test_referenceDate02() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate03() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 2 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate04() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 3 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate05() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 4 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate06() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 5 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate07() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 6 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate08() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 7 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate09() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 8 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    func test_referenceDate30_firstPage() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 30 * 7))

        FBSnapshotVerifyViewController(sut)
    }

    /// This test fails
    func test_referenceDate30_secondPage() {
        make(dayCreated: .referenceValue,
             today: .referenceValue.adding(days: 30 * 7))

        scrollToPage(1)

        FBSnapshotVerifyViewController(sut)
    }

    private func scrollToPage(_ number: Int) {
        let pdfView = sut.viewRoot

        guard let document = pdfView.document,
              let page = document.page(at: number) else { return }

        let firstPageBounds = page.bounds(for: pdfView.displayBox)
        let rect = CGRect(x: 0, y: firstPageBounds.height, width: 1.0, height: 1.0)

        pdfView.go(to: rect, on: page)
    }
}
