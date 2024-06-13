//
//  HourDistributionViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class HourDistributionViewTests: XCTestCase {
    private var sut: HourDistributionView!
    
    override func setUp() {
        super.setUp()
        sut = HourDistributionView()
        sut.viewModel = Loadable<HourDistributionViewModel>()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_viewModel() { XCTAssertNotNil(sut.viewModel) }
}
