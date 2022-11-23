//
//  ClockControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import Foundation

import XCTest

class ClockControllerTests: XCTestCase {
    private var sut: ClockController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "Event")
        sut = ClockController(event: event)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty_has144sections() {
        forceViewToLayoutInScreenSize()

        XCTAssertEqual(sut.viewRoot.clockFace.layer.sublayers?.count, 144)
    }

    func test_empty_allSectionsAreEmpty() throws {
        forceViewToLayoutInScreenSize()

        let allSectionLayers = try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer])

        let filteredSectionsLayers = allSectionLayers.filter {
            $0.section.variant != .empty
        }

        XCTAssertEqual(filteredSectionsLayers.count, 0)
    }

    func test_singleHappening_hasOneNotEmptySection() throws {
        let event = Event(name: "EventWithOneHappening")
        event.addHappening(date: .now.addingTimeInterval(-1))
        sut = ClockController(event: event)

        forceViewToLayoutInScreenSize()

        let allSectionLayers = try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer])

        let filteredSectionsLayers = allSectionLayers.filter {
            $0.section.variant != .empty
        }

        XCTAssertEqual(filteredSectionsLayers.count, 1)
    }

    /// Method makes layoutSubviews() work
    private func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}
