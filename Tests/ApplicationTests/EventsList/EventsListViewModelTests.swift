//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewModelTests: XCTestCase {
    var sut: EventsListViewModel!
    
    override func setUp() {
        super.setUp()
        let appC = ApplicationContainer(mode: .unitTest)
        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    /// This test covers container more then a `EventsListViewModel`
    func test_cellAtIndex_noEvents_firstCellIsHintCell() {
        let cell = sut.cellAt(identifier: HintCellViewModel(events: []).identifier)
        
        XCTAssertTrue(cell is HintCellViewModel)
        guard let cell = cell as? HintCellViewModel else { XCTFail(); return }
        XCTAssertEqual(cell.title, HintCellViewModel.HintState.addFirstEvent.text, "first hint must be to add first event")
    }
    
    func test_cellAtIndex_noEvents_secondCellIsFooterCell() {
        let cell = sut.cellAt(identifier: FooterCellViewModel(eventsCount: 0, tapHandler: nil).identifier)
        
        XCTAssertTrue(cell is FooterCellViewModel)
    }
    
    func test_cellAtIndex_oneEvent_secondCellIsEventCell() {
        let id = configureSUTWithOneEvent()
    
        let cell = sut.cellAt(identifier: id)
        
        XCTAssertTrue(cell is EventCellViewModel)
    }
    
    func test_cellAtIndex_oneEvent_hintAsksToSwipeEvent() {
        configureSUTWithOneEvent()
        
        let cell = sut.cellAt(identifier: HintCellViewModel(events: []).identifier)
        
        XCTAssertTrue(cell is HintCellViewModel)
        guard let cell = cell as? HintCellViewModel else { XCTFail(); return }
        XCTAssertEqual(cell.title, HintCellViewModel.HintState.swipeFirstTime.text, "second hint must be to swipe added event")
    }
    
    func test_eventCell_animation_none() {
        let id = configureSUTWithOneEvent()
        
        let cell = sut.cellAt(identifier: id)
        
        if let cell = cell as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }
    }
    
    func test_configureAnimationForEventCells_usingOldValue_addedHappeningForSecondEvent_neighboursReceiveAnimations() {
        let (a, b, c) = configureSUTWithThreeEventsAndOldValue()
        
        if let cell = sut.cellAt(identifier: a) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .aboveSwipe)
        } else { XCTFail() }
        
        if let cell = sut.cellAt(identifier: b) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .swipe)
        } else { XCTFail() }
        
        if let cell = sut.cellAt(identifier: c) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .belowSwipe)
        } else { XCTFail() }
    }
    
    func test_configureAnimationForEventCells_usingSameValue_noneForAllCells() {
        let (a, b, c) = configureSUTWithThreeEvents()
        
        sut = sut.configureAnimationForEventCells(sut)
        
        if let cell = sut.cellAt(identifier: a) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }
        
        if let cell = sut.cellAt(identifier: b) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }
        
        if let cell = sut.cellAt(identifier: c) as? EventCellViewModel {
            XCTAssertEqual(cell.animation, .none)
        } else { XCTFail() }
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfSecondEventCell_returnsFirst() {
        let (a, b, _) = configureSUTWithThreeEvents()

        XCTAssertEqual(sut.eventCellIdPrevious(to: b), a)
    }

    func test_eventCellIdPreviousTo_threeEventsByAlphabet_idOfFirstEventCell_returnsNil() {
        let (a, _, _) = configureSUTWithThreeEvents()

        XCTAssertNil(sut.eventCellIdPrevious(to: a))
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfSecondEventCell_returnsThird() {
        let (_, b, c) = configureSUTWithThreeEvents()

        XCTAssertEqual(sut.eventCellIdNext(to: b), c)
    }

    func test_eventCellIdNextTo_threeEventsByAlphabet_idOfThirdEventCell_returnsNil() {
        let (_, _, c) = configureSUTWithThreeEvents()

        XCTAssertNil(sut.eventCellIdNext(to: c))
    }
    
    func test_isEventAtIndex_noEvents_firstAndSecondIndex_false() {
        XCTAssertFalse(sut.isEventAt(index: 0))
        XCTAssertFalse(sut.isEventAt(index: 1))
    }
    
    func test_isEventAtIndex_oneEvent_firstIndex_false() {
        configureSUTWithOneEvent()
        
        XCTAssertFalse(sut.isEventAt(index: 0))
    }
    
    func test_isEventAtIndex_oneEvent_secondIndex_true() {
        configureSUTWithOneEvent()
        
        XCTAssertTrue(sut.isEventAt(index: 1))
    }
    
    private func configureSUTWithThreeEvents() -> (a: String, b: String, c: String) {
        let eventA = Event(name: "A", dateCreated: DayIndex.referenceValue.date)
        let eventB = Event(name: "B", dateCreated: DayIndex.referenceValue.date)
        let eventC = Event(name: "C", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(eventA)
        appC.commander.save(eventB)
        appC.commander.save(eventC)

        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
        return (eventA.id, eventB.id, eventC.id)
    }
    
    @discardableResult
    private func configureSUTWithOneEvent() -> String {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(event)
        let container = EventsListContainer(appC)
        sut = container.makeEventsListViewModel(nil)
        return event.id
    }
    
    private func configureSUTWithThreeEventsAndOldValue() -> (a: String, b: String, c: String) {
        let eventA = Event(name: "A", dateCreated: DayIndex.referenceValue.date)
        let eventB = Event(name: "B", dateCreated: DayIndex.referenceValue.date)
        let eventC = Event(name: "C", dateCreated: DayIndex.referenceValue.date)
        let appC = ApplicationContainer(mode: .unitTest)
        appC.commander.save(eventA)
        appC.commander.save(eventB)
        appC.commander.save(eventC)
        let container = EventsListContainer(appC)
        let oldValue = container.makeEventsListViewModel(nil)
        
        eventB.addHappening(date: DayIndex.referenceValue.date)
        appC.commander.save(eventB)
        
        sut = container.makeEventsListViewModel(nil)
        sut = sut.configureAnimationForEventCells(oldValue)
        return (eventA.id, eventB.id, eventC.id)
    }
}
