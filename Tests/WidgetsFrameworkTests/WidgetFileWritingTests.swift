//
//  FileWidgetRepositoryTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 22.09.2022.
//

import WidgetsFramework
import IosUseCases
import XCTest

class WidgetFileWritingTests: XCTestCase {
    private var sut: WidgetFileWriting!

    override func setUp() {
        super.setUp()

        sut = WidgetFileWriter()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }
}
