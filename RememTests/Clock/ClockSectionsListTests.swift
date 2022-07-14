//
//  ClockSectionsListTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class ClockSectionsListTests: XCTestCase {
    private var sut: ClockSectionsList!
    private let stitchesPer24hours = 72 * 2
    private var context: NSManagedObjectContext!

    override func setUp() {
        sut = ClockSectionsList(start: .makeStartOfDay(),
                                end: .makeMidday(),
                                sectionsPer24h: stitchesPer24hours,
                                freshCountableEventHappeningDescription: nil)

        let container = CoreDataStack.createContainer(inMemory: true)
        context = container.viewContext
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testSize() {
        XCTAssertEqual(sut.size, stitchesPer24hours / 2)
    }

    func testFill_firstSection() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 1)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 0)
    }

    func testFill_secondSection() {
        let date = makeTodayDate(withTime: (h: 0, m: 11, s: 1))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 1)
    }

    func testFill_thirdSection() {
        let date = makeTodayDate(withTime: (h: 0, m: 21, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 2)?.happeningsAmount, 1)
    }

    func testFill_lastSection() {
        let date = makeTodayDate(withTime: (h: 11, m: 59, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 2)?.happeningsAmount, 0)

        XCTAssertEqual(sut.section(at: sut.size - 1)?.happeningsAmount, 1)
        XCTAssertEqual(sut.section(at: sut.size - 2)?.happeningsAmount, 0)
    }

    func testFill_beforeLastSection() {
        let date = makeTodayDate(withTime: (h: 11, m: 49, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: 2)?.happeningsAmount, 0)

        XCTAssertEqual(sut.section(at: sut.size - 1)?.happeningsAmount, 0)
        XCTAssertEqual(sut.section(at: sut.size - 2)?.happeningsAmount, 1)
    }

    func testFill_notInRange() {
        let date = makeTodayDate(withTime: (h: 13, m: 0, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        for i in 0 ... sut.size - 1 {
            XCTAssertEqual(sut.section(at: i)?.happeningsAmount, 0)
        }
    }

    func testFill_dayRange() {
        sut = ClockSectionsList(start: .makeMidday(),
                                end: .makeEndOfDay(),
                                sectionsPer24h: stitchesPer24hours,
                                freshCountableEventHappeningDescription: nil)

        let date = makeTodayDate(withTime: (h: 12, m: 1, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.happeningsAmount, 1)
        XCTAssertEqual(sut.section(at: 1)?.happeningsAmount, 0)
    }

    func testFill_freshCountableEventHappeningDescription() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let point = makeCountableEventHappeningDescription(by: date)
        sut = ClockSectionsList(start: .makeStartOfDay(),
                                end: .makeMidday(),
                                sectionsPer24h: stitchesPer24hours,
                                freshCountableEventHappeningDescription: point)

        sut.fill(with: [point])

        XCTAssertEqual(sut.section(at: 0)?.hasFreshCountableEventHappeningDescription, true)
        XCTAssertEqual(sut.section(at: 1)?.hasFreshCountableEventHappeningDescription, false)
    }

    func testSegmentSizeMiddle() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))

        let point = makeCountableEventHappeningDescription(by: date)
        let point2 = makeCountableEventHappeningDescription(by: date2)

        sut.fill(with: [point, point2])

        XCTAssertEqual(sut.section(at: 0)?.variant, ClockSection.VisualVariant.mid)
    }

    func testSegmentSizeBig() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let date3 = makeTodayDate(withTime: (h: 0, m: 0, s: 2))

        let point = makeCountableEventHappeningDescription(by: date)
        let point2 = makeCountableEventHappeningDescription(by: date2)
        let point3 = makeCountableEventHappeningDescription(by: date3)

        sut.fill(with: [point, point2, point3])

        XCTAssertEqual(sut.section(at: 0)?.variant, ClockSection.VisualVariant.big)
    }

    func testSegmentMakingWithBigInt() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let date3 = makeTodayDate(withTime: (h: 0, m: 0, s: 2))
        let date4 = makeTodayDate(withTime: (h: 0, m: 0, s: 3))

        let point1 = makeCountableEventHappeningDescription(by: date)
        let point2 = makeCountableEventHappeningDescription(by: date2)
        let point3 = makeCountableEventHappeningDescription(by: date3)
        let point4 = makeCountableEventHappeningDescription(by: date4)

        sut.fill(with: [point1, point2, point3, point4])

        XCTAssertEqual(sut.section(at: 0)?.variant, ClockSection.VisualVariant.big)
    }
}

// MARK: - Private
extension ClockSectionsListTests {
    private func makeTodayDate(withTime: (h: Int, m: Int, s: Int)) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)
        components.hour = withTime.h
        components.minute = withTime.m
        components.second = withTime.s
        return calendar.date(from: components)!
    }

    private func makeCountableEventHappeningDescription(by date: Date) -> CountableEventHappeningDescription {
        let point = CountableEventHappeningDescription(context: context)
        point.dateCreated = date
        return point
    }
}
