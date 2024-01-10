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
        let sut = make()

        XCTAssertEqual(sut.pickerDate, sut.currentMoment)
    }

    func test_init_pickerDateProvided_pickerDate_isProvidedValue() {
        let pickerDate = DayIndex.referenceValue.date.addingTimeInterval(60 * 60 * 1)
        let sut = make(pickerDate: pickerDate)

        XCTAssertEqual(sut.pickerDate, pickerDate)
    }

    func test_cellsCount_noHappenings_zero() {
        let sut = make()

        XCTAssertEqual(sut.cellsCount, 0)
    }

    func test_cellsCount_oneHappening_one() {
        let sut = make(happenings: [DayIndex.referenceValue.date])

        XCTAssertEqual(sut.cellsCount, 1)
    }

    func test_animation_none() {
        let sut = make()

        XCTAssertEqual(sut.animation, DayDetailsViewModel.Animation.none)
    }

    func test_enableDrag_mutatesAnimationTo_deleteDropArea() {
        var sut = make()

        sut.enableDrag()

        XCTAssertEqual(sut.animation, .deleteDropArea)
    }

    func test_disableDrag_mutatesAnimationTo_none() {
        var sut = make()

        sut.disableDrag()

        XCTAssertEqual(sut.animation, .none)
    }

    func test_handlePickerDate_mutatesPickerDate() {
        var sut = make()

        let oneHourFromStart = DayIndex.referenceValue.date.addingTimeInterval(60 * 60 * 1)

        sut.handlePicker(date: oneHourFromStart)

        XCTAssertEqual(sut.pickerDate, oneHourFromStart)
    }

    private func make(happenings: [Date] = [], pickerDate: Date? = nil) -> DayDetailsViewModel {
        let appC = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        for date in happenings { event.addHappening(date: date) }
        return DayDetailsContainer(
            EventDetailsContainer(appC, event: event),
            startOfDay: DayIndex.referenceValue.date
        ).makeDayDetailsViewModel(pickerDate: pickerDate)
    }
}
