//
//  LocalFileTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

@testable import Application
import DataLayer
import XCTest

final class URLProvidingTests: XCTestCase {
    func test_LocalFile_providesFilesURLs() {
        XCTAssertTrue(LocalFile.testingPdfReport.url.isFileURL)
        XCTAssertTrue(LocalFile.pdfReport.url.isFileURL)
        XCTAssertTrue(LocalFile.testingWidget.url.isFileURL)
        XCTAssertTrue(LocalFile.widget.url.isFileURL)
    }
}
