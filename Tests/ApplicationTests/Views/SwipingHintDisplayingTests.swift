//
//  SwipingHintDisplayingTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.01.2023.
//

@testable import Application
import XCTest

final class SwipingHintDisplayingTests: XCTestCase {
    final class ParentView: UIView, UsingSwipingHintDisplaying {}
    var sut: ParentView!
    var display: SwipingHintDisplaying!

    override func setUp() {
        super.setUp()
        sut = ParentView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        display = sut.addSwipingHint()
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        window.addSubview(sut)
//        window.isHidden = false
        sut.layoutIfNeeded()
    }

    override func tearDown() {
        sut = nil
        display = nil
        super.tearDown()
    }

    func test_addSwipingHintDisplay_addSwipingHintAsSubview() {
        sut.addSwipingHint()

        XCTAssertNotNil(sut.swipingHint)
    }

    func test_startAnimation_increasesHorizontalPosition() {
        XCTAssertEqual(display.animatedPosition, 0.0, "precondition")

        display.startAnimation()

        XCTAssertLessThan(0, display.animatedPosition)
    }

    func test_startAnimation_reversesAfterCompletion() {
        let expectation = XCTestExpectation(description: "animation finished")
        display.animationCompletionHandler = {
            expectation.fulfill()
        }

        display.startAnimation()

        XCTAssertLessThan(0, display.animatedPosition, "precondition")

        wait(for: [expectation], timeout: 12.0)

        XCTAssertEqual(sut.swipingHint?.animatedPosition, 0)
    }

    func test_remove_removesSwipingHintDisplayFromSubviews() {
        XCTAssertNotNil(sut.swipingHint, "precondition")

        sut.removeSwipingHint()

        XCTAssertNil(sut.swipingHint)
    }
}
