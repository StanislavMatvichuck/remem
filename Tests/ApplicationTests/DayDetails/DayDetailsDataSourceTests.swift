//
//  DayDetailsDataSourceTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 06.02.2024.
//

@testable import Application
import Foundation
import XCTest

final class DayDetailsDataSourceTests: XCTestCase {
    private var sut: DayDetailsDataSource!
    
    override func setUp() {
        super.setUp()
        sut = DayDetailsDataSource(UICollectionView())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() {
        XCTAssertNotNil(sut)
    }
}
