//
//  ViewControllersUpdaterTests.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.03.2023.
//

@testable import Application
import XCTest

final class UpdatingDelegateSpy: Updating {
    var calledCount = 0
    func update() { calledCount += 1 }
}

final class ViewControllersUpdaterTests: XCTestCase {
    func test_init() {
        ViewControllersUpdater()
    }

    func test_conformsToUpdating() {
        XCTAssertTrue(ViewControllersUpdater() is Updating)
    }

    func test_canAddUpdatingDelegate() {
        let delegate = UpdatingDelegateSpy()
        let sut = ViewControllersUpdater()
        sut.addDelegate(delegate)
    }

    func test_update_callsDelegate() {
        let delegate = UpdatingDelegateSpy()
        let sut = ViewControllersUpdater()
        sut.addDelegate(delegate)

        sut.update()

        XCTAssertEqual(delegate.calledCount, 1)

        sut.update()

        XCTAssertEqual(delegate.calledCount, 2)
    }

    func test_addDelegate_severalTimes_addsOneDelegate() {
        let delegate = UpdatingDelegateSpy()
        let sut = ViewControllersUpdater()

        sut.addDelegate(delegate)
        sut.addDelegate(delegate)
        sut.addDelegate(delegate)

        XCTAssertEqual(sut.delegates.count, 1)

        sut.update()

        XCTAssertEqual(delegate.calledCount, 1)
    }

    func test_addDelegate_nullifyDelegate_delegatesCount_0() {
        var delegate: Updating? = UpdatingDelegateSpy()
        let sut = ViewControllersUpdater()

        sut.addDelegate(delegate!)

        delegate = nil

        XCTAssertEqual(sut.delegates.count, 0)
    }

    func test_addDelegate_addTwoObjects_addsTwoWrappers() {
        let delegate01 = UpdatingDelegateSpy()
        let delegate02 = UpdatingDelegateSpy()

        let sut = ViewControllersUpdater()
        sut.addDelegate(delegate01)
        sut.addDelegate(delegate02)

        XCTAssertEqual(sut.delegates.count, 2)
    }
}
