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

    func test_empty_allSectionsAreEmpty() {
        XCTAssertEqual(nonEmptySections.count, 0)
    }

    func test_singleHappening_oneSectionIsNotEmpty() {
        addOneHappening()

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atOneTime_oneSectionIsNotEmpty() {
        for _ in 0 ..< sut.viewModel.size {
            addOneHappening()
        }

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atTwoTimes_twoSectionsHaveEqualSize() {
        let time = TimeComponents(h: 12, m: 30, s: 45)
        let time02 = TimeComponents(h: 13, m: 35, s: 45)

        addOneHappening(at: time)
        addOneHappening(at: time02)

        XCTAssertEqual(nonEmptySections.count, 2, "precondition")
        // TODO: add size comparison
    }

    func test_manyHappenings_moreAtExactHour_hourSectionsAreBigger() {}
    func test_manyHappenings_evenlyDistributed_allSectionsEqualSize() {}
    func test_manyHappenings_randomlyDistributed_atLeastOneSectionFull() {
        for _ in 0 ..< Int.random(in: 1 ..< 100) {
            addOneHappening(at: TimeComponents(
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

        sut = ClockController(
            event: event,
            useCase: useCase,
            sorter: DefaultClockSorter(size: 144)
        )

        forceViewToLayoutInScreenSize()

        useCase.addHappening(to: event, date: .now)

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    private func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }

    private var sections: [ClockLayer] {
        do {
            return try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [ClockLayer])
        } catch { return [] }
    }

    private var nonEmptySections: [ClockLayer] {
        sections.filter { $0.viewModel.length != 0.0 }
    }

    private func addOneHappening(
        at: TimeComponents = TimeComponents(h: 1, m: 1, s: 1)
    ) {
        var today = DayComponents(date: .now).value
        today.hour = at.h
        today.minute = at.m
        today.second = at.s
        let event = sut.event

        guard let date = Calendar.current.date(from: today)
        else { fatalError("error making time for insertion") }
        event.addHappening(date: date)
        sut.update(event: event)
    }
}

private struct TimeComponents {
    let h: Int
    let m: Int
    let s: Int
}
