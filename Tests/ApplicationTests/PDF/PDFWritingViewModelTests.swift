//
//  PdfMakingViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 03.12.2023.
//

@testable import Application
import XCTest

final class PDFWritingViewModelTests: XCTestCase {
    func test_localisedTitle() {
        XCTAssertEqual(PDFWritingViewModel.title, String(localizationId: "pdf.create"))
    }
}
