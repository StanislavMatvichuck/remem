//
//  DayDetailsViewModelTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

final class DayDetailsViewModelTests: XCTestCase {
    func test_cellsCount_noHappenings_zero() {
        let sut = make(happenings: [])

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_cellsCount_oneHappening_one() {
        let sut = make(happenings: [DayIndex.referenceValue.date])

        XCTAssertEqual(sut.cellsCount, 1)
    }

    private func make(happenings: [Date]) -> DayDetailsViewModel {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        for date in happenings { event.addHappening(date: date) }
        return DayDetailsContainer(EventDetailsContainer(appC, event: event), startOfDay: DayIndex.referenceValue.date).makeDayDetailsViewModel()
    }
}
