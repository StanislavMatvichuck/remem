//
//  PdfViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 13.03.2023.
//

@testable import Application
import XCTest

final class PdfViewControllerTests: XCTestCase {
    func test_init_requiresURLProviding() {
        let sut = PdfViewController(LocalFile.testingPdfReport)
    }
}
