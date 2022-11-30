//
//  ClockControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import IosUseCases
import XCTest

class ClockControllerTests: XCTestCase {
    private var sut: ClockController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "Event")
        sut = ClockController.make(event: event)
        sut.loadViewIfNeeded()
        forceViewToLayoutInScreenSize()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty_has144sections() {
        XCTAssertEqual(sections.count, 144)
    }

    func test_empty_allSectionsAreEmpty() throws {
        XCTAssertEqual(nonEmptySections.count, 0)
    }

    func test_singleHappening_oneSectionIsNotEmpty() throws {
        let event = sut.event
        event.addHappening(date: .now)
        sut.update(event: event)

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_evenlyDistributed_allSectionsEqualSize() {}
    func test_manyHappenings_moreAtExactHour_hourSectionsAreBigger() {}
    func test_manyHappenings_atOneTime_oneSectionIsNotEmpty() {}
    func test_manyHappenings_atTwoTimes_twoSectionsHaveEqualSize() {}
    func test_manyHappenings_randomlyDistributed_oneSectionFull() {}
    func test_manyHappenings_randomlyDistributed_oneSectionEmpty() {}

    func test_receivesUpdatesFromEditUseCasing() throws {
        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()

        sut = ClockController(event: event, useCase: useCase)

        forceViewToLayoutInScreenSize()

        useCase.addHappening(to: event, date: .now)

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    private func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }

    private var sections: [ClockSectionAnimatedLayer] {
        do {
            return try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer])
        } catch { return [] }
    }

    private var nonEmptySections: [ClockSectionAnimatedLayer] {
        sections.filter { $0.section.variant != .empty }
    }
}
