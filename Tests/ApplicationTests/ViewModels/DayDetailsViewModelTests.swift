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
    func test_init_pickerDateNil_pickerDate_isCurrentMoment() {
        let sut = make(happenings: [])

        XCTAssertEqual(sut.pickerDate, sut.currentMoment)
    }

    func test_init_pickerDateProvided_pickerDate_isProvidedValue() {
        let pickerDate = DayIndex.referenceValue.date.addingTimeInterval(60 * 60 * 1)
        let sut = make(happenings: [], pickerDate: pickerDate)

        XCTAssertEqual(sut.pickerDate, pickerDate)
    }

    func test_cellsCount_noHappenings_zero() {
        let sut = make(happenings: [])

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_cellsCount_oneHappening_one() {
        let sut = make(happenings: [DayIndex.referenceValue.date])

        XCTAssertEqual(sut.cellsCount, 1)
    }

    func test_handlePickerDate_mutatesPickerDate() {
        var sut = make(happenings: [])

        let oneHourFromStart = DayIndex.referenceValue.date.addingTimeInterval(60 * 60 * 1)

        sut.handlePicker(date: oneHourFromStart)

        XCTAssertEqual(sut.pickerDate, oneHourFromStart)
    }

    private func make(happenings: [Date], pickerDate: Date? = nil) -> DayDetailsViewModel {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        for date in happenings { event.addHappening(date: date) }
        return DayDetailsContainer(
            EventDetailsContainer(appC, event: event),
            startOfDay: DayIndex.referenceValue.date
        ).makeDayDetailsViewModel(pickerDate: pickerDate)
    }
}
