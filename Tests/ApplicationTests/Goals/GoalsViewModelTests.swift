//
//  GoalsViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

@testable import Application
import Foundation
import XCTest

final class GoalsViewModelTests: XCTestCase {
    private var sut: GoalsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = GoalsViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_sections() { XCTAssertNotNil(sut.sections) }
    func test_identifiersForSection() { XCTAssertNotNil(sut.cellsIdentifiers(for: .goals)) }
    func test_cellForIdentifier() { XCTAssertNil(sut.cell(identifier: "")) }
}
