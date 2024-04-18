//
//  PdfViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

@testable import Application
import DataLayer
import XCTest

final class PDFReadingControllerTests: XCTestCase {
    func test_init_requiresURLProviding() { PDFReadingController(url: LocalFile.testingPdfReport.url) }
}
