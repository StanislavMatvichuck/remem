//
//  EventsSortingViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventsSortingViewTests: XCTestCase {
    private var sut: EventsSortingView!

    override func setUp() {
        super.setUp()
        let controller = EventsSortingContainer.makeForUnitTests().makeEventsOrderingController(using: ShowEventsOrderingServiceArgument(offset: 0.0, oldValue: nil))
        controller.loadViewIfNeeded()
        sut = controller.viewRoot
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_init() { XCTAssertNotNil(sut) }
    func test_displaysFourCellsAndSpacer() { XCTAssertEqual(sut.stack.arrangedSubviews.count, 4) }
}
