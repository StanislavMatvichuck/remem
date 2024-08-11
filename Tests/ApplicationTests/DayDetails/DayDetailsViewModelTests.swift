//
//  DayDetailsViewModelTests.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import DataLayer
import Domain
import XCTest

final class DayDetailsViewModelTests: XCTestCase {
    private var sut: DayDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = make()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_title_displaysStartOfDayFormattedName() {
        XCTAssertEqual(sut.title, "1 January")
        
        sut = make(startOfDay: DayIndex.referenceValue.adding(days: 1).date)
        
        XCTAssertEqual(sut.title, "2 January")
    }
    
    func test_isToday_true() { XCTAssertTrue(sut.isToday) }
    func test_isToday_startOfDayNextDay_false() {
        sut = make(startOfDay: DayIndex.referenceValue.adding(days: 1).date)
        
        XCTAssertFalse(sut.isToday)
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
    
    func test_identifiers() { XCTAssertEqual(sut.identifiers.count, 0) }
    
    func test_cellForIdentifier() {
        sut = make(happenings: [Happening(dateCreated: DayIndex.referenceValue.date)])

        XCTAssertNotNil(sut.cell(for: sut.identifiers.first!))
    }
    
    private func make(
        startOfDay: Date = DayIndex.referenceValue.date,
        happenings: [Happening] = []
    ) -> DayDetailsViewModel {
        let event = Event.make(with: happenings)
        let reader = CoreDataEventsRepository(container: CoreDataStack.createContainer(inMemory: true))
        reader.create(event: event)
        
        return DayDetailsViewModel(
            currentMoment: DayIndex.referenceValue.date,
            startOfDay: startOfDay,
            pickerDate: nil,
            eventsReader: reader,
            eventId: event.id
        )
    }
}
