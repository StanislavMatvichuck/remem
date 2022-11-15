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
    /// Created by `arrangeLittleSwipeRightInProgress()`
    var mockGestureRecognizer: UIPanGestureRecognizerMock?
    /// Reference must be held for parent during pan gestures tests
    private var parent: UIView!

    override func setUp() {
        super.setUp()
        sut = Swiper()
        let parentView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width * 0.8,
                                              height: EventCell.height))
        parentView.addSubview(sut)
        parentView.layoutIfNeeded()
        parent = parentView
    }

    override func tearDown() {
        parent = nil
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
        arrangeLittleSwipeRightInProgress()

        XCTAssertLessThan(sut.initialX, sut.horizontalConstraint.constant)
    }

    func test_swipingRight_releaseAtMiddle_movesCircleToInitialPosition() {
        arrangeLittleSwipeRightInProgress()

        let exp = XCTestExpectation(description: "animation completed")
        sut.animationCompletionHandler = { _ in
            exp.fulfill()
        }

        mockGestureRecognizer?.pan(location: nil, translation: nil, state: .ended)

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual(sut.horizontalConstraint.constant, sut.initialX)
    }

    func test_swipingRight_releaseAtEnd_sendsAction() {
        let exp = XCTestExpectation(description: "action sent by swiper")
        let spy = Spy(exp)
        sut.addTarget(spy, action: #selector(Spy.handleAction), for: .primaryActionTriggered)

        arrangeLittleSwipeRightInProgress(moveBy: .greatestFiniteMagnitude)
        mockGestureRecognizer?.pan(location: nil, translation: nil, state: .ended)

        wait(for: [exp], timeout: 0.1)
    }

    private func arrangeLittleSwipeRightInProgress(moveBy: CGFloat = 20) {
        let mockGR = UIPanGestureRecognizerMock(
            target: sut,
            action: #selector(Swiper.handlePan)
        )
        mockGestureRecognizer = mockGR

        sut.addGestureRecognizer(mockGR)

        let someTranslation = CGPoint(x: moveBy, y: 0)
        mockGR.pan(location: nil, translation: someTranslation, state: .changed)
    }
}

private class Spy {
    let exp: XCTestExpectation

    init(_ exp: XCTestExpectation) { self.exp = exp }

    @objc func handleAction() { exp.fulfill() }
}
