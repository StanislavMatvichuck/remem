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
    var mockGestureRecognizer: UIPanGestureRecognizerMock?
    var parent: UIView! /// Reference must be held for parent during pan gestures tests
    var circlePosition: CGFloat { sut.horizontalConstraint.constant }

    override func setUp() {
        super.setUp()
        let sut = Swiper()
        self.sut = sut

        let parentView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width * 0.8,
                                              height: EventCell.height))
        parentView.addSubview(sut)
        parentView.layoutIfNeeded()
        parent = parentView
    }

    override func tearDown() {
        executeRunLoop()
        parent = nil
        mockGestureRecognizer = nil
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
        XCTAssertLessThan(sut.initialX, sut.successX)
        XCTAssertLessThanOrEqual(sut.successX, sut.width - sut.size / 2)
    }

    func test_swipingRight_movesCircleRight() {
        XCTAssertEqual(sut.initialX, circlePosition, "precondition")
        addMockGestureRecognizer()

        mockGestureRecognizer?.pan(
            location: nil,
            translation: CGPoint(x: 20, y: 0),
            state: .changed
        )

        XCTAssertLessThan(sut.initialX, circlePosition)
    }

    func test_swipingRight_releaseAtMiddle_movesCircleToInitialPosition() {
        addMockGestureRecognizer()

        mockGestureRecognizer?.pan(
            location: nil,
            translation: CGPoint(x: 20, y: 0),
            state: .changed
        )

        XCTAssertLessThan(sut.initialX, circlePosition, "precondition")

        mockGestureRecognizer?.pan(location: nil, translation: nil, state: .ended)

        XCTAssertEqual(sut.initialX, circlePosition)
    }

    func test_swipingRight_releaseAtEnd_sendsAction() {
        let exp = XCTestExpectation(description: "action sent by swiper")
        let spy = Spy(exp)
        sut.addTarget(spy, action: #selector(Spy.handleAction), for: .primaryActionTriggered)

        releaseFingerAtEnd()

        wait(for: [exp], timeout: 0.001)
    }

    func test_swipingRight_releaseAtEnd_returnsCircleBackAfterAnimation() {
        let exp02 = XCTestExpectation(description: "circle returns to initial position")
        sut.animationCompletionHandler = { _ in exp02.fulfill() }

        releaseFingerAtEnd()

        XCTAssertLessThan(sut.initialX, circlePosition, "circle is not returned immediately")

        wait(for: [exp02], timeout: 0.001)

        XCTAssertEqual(sut.initialX, circlePosition)
    }

    private func releaseFingerAtEnd() {
        addMockGestureRecognizer()

        mockGestureRecognizer?.pan(
            location: nil,
            translation: CGPoint(x: CGFloat.greatestFiniteMagnitude, y: 0),
            state: .changed
        )

        mockGestureRecognizer?.pan(
            location: nil,
            translation: nil,
            state: .ended
        )
    }

    private func addMockGestureRecognizer() {
        let mockGR = UIPanGestureRecognizerMock(
            target: sut,
            action: #selector(Swiper.handlePan)
        )
        sut.addGestureRecognizer(mockGR)
        mockGestureRecognizer = mockGR
    }
}

private class Spy {
    let exp: XCTestExpectation

    init(_ exp: XCTestExpectation) { self.exp = exp }

    @objc func handleAction() { exp.fulfill() }
}
