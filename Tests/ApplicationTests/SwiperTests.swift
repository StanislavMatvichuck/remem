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
        sut = Swiper()
        let parentView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width * 0.8,
                                              height: EventCell.height))
        parentView.addSubview(sut)
        parentView.layoutIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_hasPanRecognizer() throws {
        let gr = sut.gestureRecognizers?.first

        _ = try XCTUnwrap(gr as? UIPanGestureRecognizer)
    }

    func test_hasNonZeroSize() {
        XCTAssertNotEqual(sut.bounds.width, 0)
        XCTAssertNotEqual(sut.bounds.height, 0)
    }

    func test_layoutRules() {
        XCTAssertLessThanOrEqual(sut.size / 2, sut.initialX)
        XCTAssertLessThanOrEqual(sut.initialX, sut.successX)
        XCTAssertLessThanOrEqual(sut.successX, sut.width - sut.size / 2)
    }

    func test_swipingRight_movesCircleRight() {
        let mockGR = UIPanGestureRecognizerMock(
            target: sut,
            action: #selector(Swiper.handlePan)
        )

        sut.addGestureRecognizer(mockGR)

        let someTranslation = CGPoint(x: 20, y: 0)
        mockGR.pan(location: nil, translation: someTranslation, state: .changed)

        XCTAssertLessThan(sut.initialX, sut.horizontalConstraint.constant)
    }
}
