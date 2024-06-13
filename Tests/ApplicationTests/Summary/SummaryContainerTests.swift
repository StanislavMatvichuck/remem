//
//  SummaryContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 13.06.2024.
//

@testable import Application
import Foundation
import XCTest

final class SummaryContainerTests: XCTestCase {
    private var sut: SummaryContainer!
    private weak var weakSUT: SummaryContainer?
    
    override func setUp() {
        super.setUp()
        sut = SummaryContainer.makeForUnitTests()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        executeRunLoop(until: .now + 0.01)
        XCTAssertNil(weakSUT)
    }
    
    // MARK: - Tests
    
    func test_hasNoReferenceCycles() {
        weakSUT = sut
        
        let controller = sut.makeSummaryController()
        controller.loadViewIfNeeded()
        controller.viewDidDisappear(false)
        
        XCTAssertNotNil(sut)
    }
}
