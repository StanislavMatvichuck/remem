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
    private var sut: DayDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date,
            startOfDay: DayIndex.referenceValue.date,
            pickerDate: nil,
            cells: [],
            eventId: ""
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_title_displaysStartOfDayFormattedName() {
        XCTAssertEqual(sut.title, "1 January")
        
        sut = DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date,
            startOfDay: DayIndex.referenceValue.adding(days: 1).date,
            pickerDate: nil,
            cells: [],
            eventId: ""
        )
        
        XCTAssertEqual(sut.title, "2 January")
    }
    
    func test_isToday_true() { XCTAssertTrue(sut.isToday) }
    func test_isToday_startOfDayNextDay_false() {
        sut = DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date,
            startOfDay: DayIndex.referenceValue.adding(days: 1).date,
            pickerDate: nil,
            cells: [],
            eventId: ""
        )
        
        XCTAssertFalse(sut.isToday)
    }
    
    func test_pickerDate_isStartOfDayWithTimeFromCurrentMoment() {
        sut = DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date.addingTimeInterval(TimeInterval(30 * 3)),
            startOfDay: DayIndex.referenceValue.adding(days: 1).date,
            pickerDate: nil,
            cells: [],
            eventId: ""
        )
        
        // this test will duplicate the implementation
    }
    
    func test_animation_nil() { XCTAssertNil(sut.animation) }
    
    func test_enableDrag_mutatesAnimationTo_deleteDropArea() {
        sut.enableDrag()

        XCTAssertEqual(sut.animation, .deleteDropArea)
    }

    func test_disableDrag_mutatesAnimationTo_none() {
        sut.disableDrag()

        XCTAssertNil(sut.animation)
    }
    
    func test_handlePickerDate_mutatesPickerDate() {
        let oneHourFromStart = DayIndex.referenceValue.date.addingTimeInterval(60 * 60 * 1)

        sut.handlePicker(date: oneHourFromStart)

        XCTAssertEqual(sut.pickerDate, oneHourFromStart)
    }
    
    // TODO: uncomment this test
    func test_assignCellsAnimations_newHappening() {
//        let app = ApplicationContainer(mode: .unitTest)
//        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
//        event.addHappening(date: DayIndex.referenceValue.date)
//        let eventDetails = EventDetailsContainer(app, event: event)
//        let container = DayDetailsContainer(eventDetails, startOfDay: DayIndex.referenceValue.date)
//        var end = container.makeDayDetailsViewModel(pickerDate: nil)
//
//        end.configureCellsAnimations(sut)
//
//        XCTAssertEqual(end.cells.first?.animation, DayCellViewModel.Animation.new)
    }
    
    func test_identifiers() { XCTAssertEqual(sut.identifiers.count, 0) }
    
    func test_cellForIdentifier() {
        let cell = DayCellViewModel(
            id: "id",
            happening: Happening(dateCreated: .distantFuture)
        )
        
        sut = DayDetailsViewModel(
            currentMoment: .distantFuture,
            startOfDay: .distantFuture,
            pickerDate: nil,
            cells: [cell],
            eventId: ""
        )
        
        XCTAssertNotNil(sut.cell(for: "id"))
    }
}
