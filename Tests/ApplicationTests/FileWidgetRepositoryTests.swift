//
//  FileWidgetRepositoryTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 22.09.2022.
//

@testable import Application
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
