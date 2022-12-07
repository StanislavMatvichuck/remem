//
//  WeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekCellViewModelTests: XCTestCase {
    private var sut: WeekItemViewModel!

    override func setUp() {
        super.setUp()
        let day = DayComponents.referenceValue
        sut = WeekItemViewModel(day: day, today: day, happenings: [])
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_empty_amountIs0() {
        XCTAssertEqual(sut.amount, "0")
    }

    func test_dayAndTodayMatches_isTodayTrue() {
        XCTAssertTrue(sut.isToday)
    }

    func test_dayAndTodayAreDifferent_isTodayFalse() {
        let day = DayComponents.referenceValue
        let dayLater = day.adding(components: DateComponents(hour: 24))
        let sut = WeekItemViewModel(day: day, today: dayLater, happenings: [])

        XCTAssertFalse(sut.isToday)
    }
    
    func test_hasDayNumber() {
        XCTAssertEqual(sut.dayNumber, "1")
    }
    
    func test_oneHappening_showsHappeningTime() {
        let day = DayComponents.referenceValue
        let happening = Happening(dateCreated: DayComponents.referenceValue.date)
        sut = WeekItemViewModel(day: day, today: day, happenings: [happening])
        
        XCTAssertEqual(sut.happeningsTimings.first, "00:00")
    }
}
