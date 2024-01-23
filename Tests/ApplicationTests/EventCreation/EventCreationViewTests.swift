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

        XCTAssertNotNil(sut.subviews[0] as? UIVisualEffectView)
    }

    func test_hasHint() {
        let sut = EventCreationView()

        XCTAssertNotNil(sut.subviews[1] as? UILabel)
    }

    func test_hasEmojiList() {
        let sut = EventCreationView()

        XCTAssertNotNil(sut.subviews[2] as? EmojiView)
    }

    func test_hasTextInput() {
        let sut = EventCreationView()

        XCTAssertNotNil(sut.subviews[3] as? UITextField)
    }
}
