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
    var sut: PdfMakingViewController!
    var calledCount = 0

    override func setUp() {
        super.setUp()

        sut = PdfMakingViewController(
            PdfMakingViewModelFactoryStub(handler: {
                [weak self] in self?.calledCount += 1
            })
        )

        sut.loadViewIfNeeded()
        tap(sut.viewRoot.button)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_tapButton_callsCompletion() {
        XCTAssertEqual(calledCount, 1)
    }

    // TODO: enable this test. How to test containers closures that consist logic in them?
//    func test_tapButton_savesPdfFile() throws {
//        let path = LocalFile.testingPdfReport.url.path
//        XCTAssertTrue(FileManager.default.fileExists(atPath: path))
//
//        // cleanup after test
//        do { try FileManager.default.removeItem(atPath: path) } catch {}
//    }

    func test_showsLocalizedTitle() {
        XCTAssertEqual(sut.viewRoot.button.titleLabel?.text, PdfMakingViewModel.title)
    }
}

struct PdfMakingViewModelFactoryStub: PdfMakingViewModelFactoring {
    let handler: PdfMakingViewModel.TapHandler

    func makePdfMakingViewModel() -> PdfMakingViewModel {
        PdfMakingViewModel(tapHandler: handler)
    }
}
