//
//  ClockViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

class ClockViewControllerTests: XCTestCase, ClockViewControllerTesting {
    var sut: ClockViewController!
    var event: Event!
    var viewModelFactory: ClockViewModelFactoring!

    override func setUp() {
        super.setUp()
        let root = ApplicationContainer(testingInMemoryMode: true)
        viewModelFactory = root
        event = Event(name: "Event")
        sut = ClockViewController(
            viewModel: viewModelFactory.makeClockViewModel(event: event)
        )
        sut.loadViewIfNeeded()
        sut.forceViewToLayoutInScreenSize()
    }

    override func tearDown() {
        sut = nil
        event = nil
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
        sendEventUpdatesToController()

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atOneTime_oneSectionIsNotEmpty() {
        for _ in 0 ..< sut.viewModel.items.count {
            addOneHappening()
        }

        sendEventUpdatesToController()

        XCTAssertEqual(nonEmptySections.count, 1)
    }

    func test_manyHappenings_atTwoTimes_twoSectionsHaveEqualSize() {
        let time = TimeComponents(h: 12, m: 30, s: 45)
        let time02 = TimeComponents(h: 13, m: 35, s: 45)

        addOneHappening(at: time)
        addOneHappening(at: time02)
        sendEventUpdatesToController()

        XCTAssertEqual(nonEmptySections.count, 2, "precondition")
        XCTAssertEqual(
            nonEmptySections[0].strokeEnd,
            nonEmptySections[1].strokeEnd
        )
    }

    /// also make snapshots for these cases
    func test_manyHappenings_moreAtExactHour_hourSectionsAreBigger() {}
    func test_manyHappenings_evenlyDistributed_allSectionsEqualSize() {
        for h in 0 ..< 24 {
            for m in 0 ..< 60 {
                addOneHappening(at: TimeComponents(h: h, m: m, s: 0))
            }
        }

        sendEventUpdatesToController()

        let size = sections.first!.strokeEnd

        XCTAssertNotEqual(size, 0.0, accuracy: 0.001, "precondition")

        for section in sections {
            XCTAssertEqual(size, section.strokeEnd)
        }
    }

    func test_manyHappenings_randomlyDistributed_atLeastOneSectionFull() {
        for _ in 0 ..< Int.random(in: 1 ..< 100) {
            addOneHappening(at: TimeComponents(
                h: Int.random(in: 0 ..< 24),
                m: Int.random(in: 0 ..< 60),
                s: Int.random(in: 0 ..< 60)
            ))
        }

        sendEventUpdatesToController()

        let fullSections = sections.filter { $0.strokeEnd == 0.96 }

        XCTAssertLessThanOrEqual(1, fullSections.count)
    }

    private var sections: [CAShapeLayer] {
        do {
            return try XCTUnwrap(sut.viewRoot.clockFace.layer.sublayers as? [CAShapeLayer])
        } catch { fatalError(error.localizedDescription) }
    }

    private var nonEmptySections: [CAShapeLayer] {
        sections.filter { $0.strokeEnd > 0.01 }
    }
}
