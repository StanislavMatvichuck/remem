//
//  PdfMakingViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 03.12.2023.
//

@testable import Application
import XCTest

final class PdfMakingViewModelTests: XCTestCase {
    func test_localisedTitle() {
        XCTAssertEqual(PdfMakingViewModel.title, String(localizationId: "pdf.create"))
    }
}
