//
//  HourDistributionViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class HourDistributionViewModelTests: XCTestCase {
    private var sut: HourDistributionViewModel!
    
    override func setUp() {
        super.setUp()
        sut = HourDistributionViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_count_24() { XCTAssertEqual(sut.count, 24) }
    func test_cellAtIndex() { XCTAssertNotNil(sut.cell(at: 0)) }
    func test_valueTotal_zero() { XCTAssertEqual(sut.valueTotal, 0) }
    
    func test_initWithHappening_valueTotal_1() {
        sut = HourDistributionViewModel([
            Happening(dateCreated: DayIndex.referenceValue.date)
        ])
        
        XCTAssertEqual(sut.valueTotal, 1)
    }
}
