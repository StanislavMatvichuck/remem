//
//  DayOfWeekViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class DayOfWeekViewTests: XCTestCase {
    func test_init() {
        let sut = DayOfWeekView()
        sut.viewModel = DayOfWeekViewModel()
    }

    func test_usesViewModel() {
        let sut = DayOfWeekView()
        sut.viewModel = DayOfWeekViewModel()

        XCTAssertNotNil(sut.viewModel)
    }
}
