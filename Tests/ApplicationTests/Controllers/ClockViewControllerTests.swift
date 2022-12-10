//
//  ClockViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import IosUseCases
import XCTest

class ClockViewControllerTests: XCTestCase {
    private var sut: ClockViewController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "Event")
        sut = ClockViewController.make(event: event)
        sut.loadViewIfNeeded()
        sut.forceViewToLayoutInScreenSize()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty_has144sections() {
        XCTAssertEqual(sections.count, 144)
    }

    func test_empty_allSectionsAreEmpty() {
        XCTAssertEqual(nonEmptySections.count, 0)
    }

    func test_singleHappening_oneSectionIsNotEmpty() {
        sut.addOneHappening()

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atOneTime_oneSectionIsNotEmpty() {
        for _ in 0 ..< sut.viewModel.size {
            sut.addOneHappening()
        }

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atTwoTimes_twoSectionsHaveEqualSize() {
        let time = TimeComponents(h: 12, m: 30, s: 45)
        let time02 = TimeComponents(h: 13, m: 35, s: 45)

        sut.addOneHappening(at: time)
        sut.addOneHappening(at: time02)

        XCTAssertEqual(nonEmptySections.count, 2, "precondition")
        // TODO: add size comparison
    }

    /// also make snapshots for these cases
    func test_manyHappenings_moreAtExactHour_hourSectionsAreBigger() {}
    func test_manyHappenings_evenlyDistributed_allSectionsEqualSize() {}
    func test_manyHappenings_randomlyDistributed_atLeastOneSectionFull() {
        for _ in 0 ..< Int.random(in: 1 ..< 100) {
            sut.addOneHappening(at: TimeComponents(
                h: Int.random(in: 0 ..< 24),
                m: Int.random(in: 0 ..< 60),
                s: Int.random(in: 0 ..< 60)
            ))
        }

        let fullSections = sections.filter { $0.viewModel.length == 1.0 }

        XCTAssertLessThanOrEqual(1, fullSections.count)
    }

    func test_receivesUpdatesFromEditUseCasing() {
        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()

        sut = ClockViewController(
            event: event,
            useCase: useCase,
            sorter: DefaultClockSorter(size: 144)
        )

        sut.forceViewToLayoutInScreenSize()

        useCase.addHappening(to: event, date: .now)

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    private var sections: [ClockItem] {
        do {
            return try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [ClockItem])
        } catch { return [] }
    }

    private var nonEmptySections: [ClockItem] {
        sections.filter { $0.viewModel.length != 0.0 }
    }
}
