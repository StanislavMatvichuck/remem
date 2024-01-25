//
//  HourDistributionCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class HourDistributionCellViewModelTests: XCTestCase {
    private var sut: HourDistributionCellViewModel!

    override func setUp() {
        super.setUp()
        sut = HourDistributionCellViewModel(0)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_init_requiresIndex() { XCTAssertNotNil(sut) } /// {} > constant, constant > scalar
    func test_relativeLength() { XCTAssertEqual(sut.relativeLength, 0) } /// {} > constant
    func test_hours() { XCTAssertEqual(sut.hours, "00") } /// {} > constant
    func test_initWithSecondIndex_hours_01() { /// constant > scalar
        sut = HourDistributionCellViewModel(1)

        XCTAssertEqual(sut.hours, "01")
    }
}
