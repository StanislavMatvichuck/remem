//
//  CoordinatorTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

@testable import Application
import XCTest

struct ControllerFactoryFake: ControllerFactoring {
    func make() -> UIViewController {
        UIViewController()
    }
}

final class NavigationTests: XCTestCase {
    func test_init_requiresFactory() {
        _ = Navigation.eventsList(factory: ControllerFactoryFake())
    }
}

final class CoordinatorTests: XCTestCase {
    func test_init_hasStyledNavigationViewController() {
        let sut = Coordinator()

        XCTAssertTrue(sut.navigationController.navigationBar.prefersLargeTitles)
    }

    func test_init_hasNoChildren() {
        let sut = Coordinator()

        XCTAssertEqual(sut.navigationController.children.count, 0)
    }

    func test_show_pushesOnStack() {
        let sut = Coordinator()

        sut.show(Navigation.eventsList(factory: ControllerFactoryFake()))

        XCTAssertEqual(sut.navigationController.children.count, 1)

        sut.show(Navigation.eventDetails(factory: ControllerFactoryFake()))

        executeRunLoop()

        XCTAssertEqual(sut.navigationController.children.count, 2)
    }
}
