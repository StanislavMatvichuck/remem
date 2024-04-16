//
//  CoordinatorTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

@testable import Application
import UIKit
import XCTest

struct ControllerFactoryFake {
    func make() -> UIViewController { UIViewController() }
}

final class CoordinatorTests: XCTestCase {
    var sut: Coordinator!
    override func setUp() { super.setUp(); sut = Coordinator() }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_init_hasStyledNavigationViewController() {
        XCTAssertTrue(sut.navigationController.navigationBar.prefersLargeTitles)
    }

    func test_init_hasNoChildren() {
        XCTAssertEqual(sut.navigationController.children.count, 0)
    }

    func test_show_pushesOnStack() {
        sut.goto(navigation: .eventsList, controller: UIViewController())

        XCTAssertEqual(sut.navigationController.children.count, 1)

        sut.goto(navigation: .eventDetails, controller: UIViewController())

        executeRunLoop()

        XCTAssertEqual(sut.navigationController.children.count, 2)
    }
}
