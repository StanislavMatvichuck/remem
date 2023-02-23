//
//  UIGestureRecognizerSpy.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import UIKit
import XCTest

class UIPanGestureRecognizerMock: UIPanGestureRecognizer {
    private let target: Any?
    private let action: Selector?
    var gestureState: UIGestureRecognizer.State?
    var gestureLocation: CGPoint?
    var gestureTranslation: CGPoint?
    var gestureVelocity: CGPoint?

    override init(target: Any?, action: Selector?) {
        self.target = target
        self.action = action
        super.init(target: target, action: action)
    }

    override func location(in view: UIView?) -> CGPoint {
        if let gestureLocation = gestureLocation {
            return gestureLocation
        }
        return super.location(in: view)
    }

    override func translation(in view: UIView?) -> CGPoint {
        if let gestureTranslation = gestureTranslation {
            return gestureTranslation
        }
        return super.translation(in: view)
    }

    override func velocity(in view: UIView?) -> CGPoint {
        if let gestureVelocity = gestureVelocity {
            return gestureVelocity
        }
        return super.velocity(in: view)
    }

    override var state: UIGestureRecognizer.State {
        get {
            if let gestureState = gestureState {
                return gestureState
            }
            return super.state
        }
        set {
            self.state = newValue
        }
    }
}

extension UIPanGestureRecognizerMock {
    func pan(
        location: CGPoint?,
        translation: CGPoint?,
        state: UIGestureRecognizer.State
    ) {
        guard let action = action else { return }
        gestureState = state
        gestureLocation = location
        gestureTranslation = translation

        (target as? NSObject)?.perform(
            action,
            on: Thread.current,
            with: self,
            waitUntilDone: true
        )
    }
}

class ReceiverMock: ViewModelDisplaying {
    private var calledCount = 0

    func update(_: String) {
        calledCount += 1
    }

    func assertCalled(
        count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(calledCount, count, file: file, line: line)
    }
}
