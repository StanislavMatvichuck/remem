//
//  CompositionRootTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 07.12.2022.
//

@testable import Application
import XCTest

class CompositionRootTests: XCTestCase {
    func test_canMakeRootViewController() {
        XCTAssertNotNil(ApplicationContainer().makeRootViewController())
    }
}
