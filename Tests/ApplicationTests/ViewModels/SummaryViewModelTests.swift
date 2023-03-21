//
//  SummaryViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 30.01.2023.
//

@testable import Application
import Domain
import XCTest

final class SummaryViewModelTests: XCTestCase {
    var sut: SummaryViewModel!
    var event: Event!

    override func setUp() {
        super.setUp()
        arrange()
    }

    override func tearDown() {
        sut = nil
        event = nil
        super.tearDown()
    }

    func test_newEvent_initialValues() {
        XCTAssertEqual(totalAmount, "0")
        XCTAssertEqual(daysTracked, "1")
        XCTAssertEqual(dayAverage, "0")
        XCTAssertEqual(daysSinceLastHappening, "0")
    }

    func test_eventWithOneHappening_totalAmount_1() {
        arrange(happenings: [Happening(dateCreated: .now)])

        XCTAssertEqual(totalAmount, "1")
    }

    func test_eventWith100Happenings_totalAmount_100() {
        arrange(happenings: (0 ..< 100).map {
            Happening(dateCreated: .now.addingTimeInterval(-0.1 * Double($0)))
        })

        XCTAssertEqual(totalAmount, "100")
    }

    func test_eventCreatedYesterday_daysTracking_2() {
        arrange(dateCreated: yesterday)

        XCTAssertEqual(daysTracked, "2")
    }

    func test_eventCreatedNowWith3Happenings_dayAverage_3() {
        arrange(happenings: [
            Happening(dateCreated: .now),
            Happening(dateCreated: .now),
            Happening(dateCreated: .now),
        ])

        XCTAssertEqual(dayAverage, "3")
    }

    func test_eventCreatedYesterdayWithHappeningEachDay_dayAverage_1() {
        arrange(
            dateCreated: yesterday,
            happenings: [
                Happening(dateCreated: yesterday),
                Happening(dateCreated: .now),
            ]
        )

        XCTAssertEqual(dayAverage, "1")
    }

    func test_eventCreatedYesterdayWithTwoHappeningsYesterday_dayAverage_1() {
        arrange(
            dateCreated: yesterday,
            happenings: [
                Happening(dateCreated: yesterday),
                Happening(dateCreated: yesterday),
            ]
        )

        XCTAssertEqual(dayAverage, "1")
    }

    func test_eventCreatedYesterdayWithTwoHappeningsYesterdayAndOneToday_dayAverage_15() {
        arrange(
            dateCreated: yesterday,
            happenings: [
                Happening(dateCreated: yesterday),
                Happening(dateCreated: yesterday),
                Happening(dateCreated: .now),
            ]
        )

        XCTAssertEqual(dayAverage, "1,5")
    }

    func test_eventWithHappeningYesterday_daysSinceLastHappening_1() {
        arrange(
            dateCreated: yesterday,
            happenings: [Happening(dateCreated: yesterday)]
        )

        XCTAssertEqual(daysSinceLastHappening, "1")
    }

    func test_eventWithHappeningWeekAgo_daysSinceLastHappening_7() {
        arrange(
            dateCreated: weekAgo,
            happenings: [Happening(dateCreated: weekAgo)]
        )

        XCTAssertEqual(daysSinceLastHappening, "7")
    }

    func test_eventCreatedWeekAgoWithHappeningYesterday_daysSinceLastHappening_1() {
        arrange(
            dateCreated: weekAgo,
            happenings: [Happening(dateCreated: yesterday)]
        )

        XCTAssertEqual(daysSinceLastHappening, "1")
    }

    func test_eventCreatedTwoWeeksAgoWithHappeningEachDay_weekAverage_7() {
        let today = DayIndex.referenceValue.adding(days: 13)
        let event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)

        for i in 0 ..< 14 {
            event.addHappening(date: DayIndex.referenceValue.adding(days: i).date)
        }

        sut = SummaryViewModel(event: event, today: today)

        XCTAssertEqual(weekAverage, "7")
    }

    // clear demonstration of too high coupling with implementation production code
    private var totalAmount: String { sut.items[0].value }
    private var daysSinceLastHappening: String { sut.items[1].value }
    private var weekAverage: String { sut.items[2].value }
    private var dayAverage: String { sut.items[3].value }
    private var daysTracked: String { sut.items[4].value }

    private func arrange(
        dateCreated: Date = .now,
        happenings: [Happening] = []
    ) {
        event = Event(name: "Event", dateCreated: dateCreated)

        for happening in happenings { event.addHappening(date: happening.dateCreated) }

        sut = SummaryViewModel(event: event, today: DayIndex(.now))
    }

    private var yesterday: Date {
        Calendar.current.date(
            byAdding: DateComponents(day: -1),
            to: .now
        )!
    }

    private var weekAgo: Date {
        Calendar.current.date(
            byAdding: DateComponents(day: -7),
            to: .now
        )!
    }
}
