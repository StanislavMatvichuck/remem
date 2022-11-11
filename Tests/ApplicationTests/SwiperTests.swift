//
//  SwiperTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import XCTest

class SwiperTests: XCTestCase {
    var sut: Swiper!

    override func setUp() {
        super.setUp()
        sut = Swiper(parent: UIView())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_hasPanRecognizer() throws {
        let gr = sut.gestureRecognizers?.first

        _ = try XCTUnwrap(gr as? UIPanGestureRecognizer)
    }

    func test_eventCellSwipe_notFull_returnsPinToStart() {
        // create mock class
        // change real class to mock
        // use mock to test behaviour
    }
}
