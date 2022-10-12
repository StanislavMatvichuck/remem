//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import XCTest

class EventsListTests: XCTestCase {
    func testInit() {
        let sut = makeSUT()
        XCTAssertNotNil(sut)
    }
}

private extension EventsListTests {
    func makeSUT() -> EventsListController {
        let applicationFactory = ApplicationFactory()
        let rootController = applicationFactory.makeRootViewController()
        do {
            let navigationVC = try XCTUnwrap(rootController as? UINavigationController)
            let eventsListVC = try XCTUnwrap(navigationVC.viewControllers[0] as? EventsListController)
            return eventsListVC
        } catch {
            fatalError("Unable to create root view controller")
        }
    }
}
