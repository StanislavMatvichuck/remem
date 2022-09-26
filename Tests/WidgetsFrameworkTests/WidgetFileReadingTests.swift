//
//  WidgetFileReadingTests.swift
//  WidgetsFrameworkTests
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import WidgetsFramework
import XCTest

class WidgetFileReadingTests: XCTestCase {
    private var sut: WidgetFileReading!

    override func setUp() {
        super.setUp()
        sut = WidgetFileReader()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_readStaticPreview() {
        let widgetPreview = sut.readStaticPreview()

        XCTAssertNotNil(widgetPreview)
    }

    func test_readApplicationDataContainer_nil() {
        XCTAssertNil(sut.readApplicationDataContainer())
    }
}
