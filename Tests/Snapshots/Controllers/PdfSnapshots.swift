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
    TestingViewController,
    AtlasProducing
{
    var sut: PDFReadingController!
    var event: Event!
    var atlas: UIView!

    override func setUp() {
        super.setUp()
        configureSnapshotsOptions()
        configureAtlasView()
        recordMode = true
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_referenceDate() {
        make(dayCreated: .referenceValue, today: .referenceValue)

        verify()
    }

    func test_referenceDate_dark() {
        make(dayCreated: .referenceValue, today: .referenceValue)

        sut.view.window?.overrideUserInterfaceStyle = .dark
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }

        verify()
    }

    func test_referenceDate02() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 7))

        verify()
    }

    func test_referenceDate03() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 2 * 7))

        verify()
    }

    func test_referenceDate04() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 3 * 7))

        verify()
    }

    func test_referenceDate05() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 4 * 7))

        verify()
    }

    func test_referenceDate06() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 5 * 7))

        verify()
    }

    func test_referenceDate07() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 6 * 7))

        verify()
    }

    func test_referenceDate08() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 7 * 7))

        verify()
    }

    func test_referenceDate09() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 8 * 7))

        verify()
    }

    func test_referenceDate30_firstPage() {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 30 * 7))

        verify()
    }

    /// This test fails
    func test_weekPage01() { verifyWeek(page: 1) }
    func test_weekPage02() { verifyWeek(page: 2) }
    func test_weekPage03() { verifyWeek(page: 3) }
    func test_weekPage04() { verifyWeek(page: 4) }
    func test_weekPage05() { verifyWeek(page: 5) }
    func test_weekPage06() { verifyWeek(page: 6) }
    func test_weekPage07() { verifyWeek(page: 7) }
    func test_weekPage08() { verifyWeek(page: 8) }
    func test_weekPage09() { verifyWeek(page: 9) }
    func test_weekPage10() { verifyWeek(page: 10) }

    private func verifyWeek(page: Int) {
        make(dayCreated: .referenceValue, today: .referenceValue.adding(days: 9 * 7))

        sut.viewRoot.pdf?.layoutIfNeeded()
        scrollTo(page: 4 + page, view: sut.viewRoot)

        verify()
    }

    func test_week_atlas() {
        makeAtlasFor(testNames: [
            "\(deviceName)/light/Pdf/test_weekPage01",
            "\(deviceName)/light/Pdf/test_weekPage02",
            "\(deviceName)/light/Pdf/test_weekPage03",
            "\(deviceName)/light/Pdf/test_weekPage04",
            "\(deviceName)/light/Pdf/test_weekPage05",
            "\(deviceName)/light/Pdf/test_weekPage06",
            "\(deviceName)/light/Pdf/test_weekPage07",
            "\(deviceName)/light/Pdf/test_weekPage08",
            "\(deviceName)/light/Pdf/test_weekPage09",
            "\(deviceName)/light/Pdf/test_weekPage10",
        ])
    }

    private func verify(
        file: StaticString = #file,
        line: UInt = #line
    ) {
        sut.viewRoot.layoutIfNeeded()

        FBSnapshotVerifyView(sut.viewRoot)
    }

    // MARK: - Public
    /// Used by tests only
    private func scrollTo(page number: Int, view: PDFReadingView) {
        guard
            let pdf = view.pdf,
            let document = pdf.document,
            let page = document.page(at: number)
        else { return }

        pdf.go(to: page)
    }
}
