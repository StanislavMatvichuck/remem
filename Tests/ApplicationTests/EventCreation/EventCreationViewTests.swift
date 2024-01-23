//
//  EventCreationViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventCreationViewTests: XCTestCase {
    func test_init() {
        let sut = EventCreationView()
    }

    func test_hasBlurView() {
        let sut = EventCreationView()

        XCTAssertNotNil(sut.subviews.first as? UIVisualEffectView)
    }
}
