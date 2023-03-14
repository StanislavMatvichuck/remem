//
//  PdfMakingViewControllerTests.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

@testable import Application
import Domain
import XCTest

final class PdfMakingViewControllerTests: XCTestCase {
    func test_tapButton_callsCompletion() {
        var calledCount = 0

        let sut = PdfMakingViewController(
            provider: LocalFile.testingPdfReport,
            pdfMaker: PdfMakingStub(),
            saver: DefaultLocalFileSaver(),
            completion: { calledCount += 1 }
        )
        sut.loadViewIfNeeded()

        tap(sut.viewRoot.button)

        XCTAssertEqual(calledCount, 1)
    }

    func test_tapButton_savesPdfFile() throws {
        let sut = PdfMakingViewController(
            provider: LocalFile.testingPdfReport,
            pdfMaker: PdfMakingStub(),
            saver: DefaultLocalFileSaver(),
            completion: {}
        )
        sut.loadViewIfNeeded()

        tap(sut.viewRoot.button)

        let path = LocalFile.testingPdfReport.url.path
        XCTAssertTrue(FileManager.default.fileExists(atPath: path))

        // cleanup after test
        do { try FileManager.default.removeItem(atPath: path) } catch {}
    }
}

struct PdfMakingStub: PDFMaking {
    func make() -> Data { Data() }
}
