//
//  EventItemViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import Domain
import XCTest

class EventItemViewModelTests: XCTestCase {
    private var sut: EventItemViewModel!

//    override func setUp() {
//        super.setUp()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//    }

    func testInit() {
        let coordinator = DefaultCoordinator()
        let commander = EventsRepositoryFake()
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: today.date)
        let sut = EventItemViewModel(
            event: event,
            today: today,
            onSelect: { _ in
                coordinator.show(UIViewController())
            },
            onSwipe: { event in
                event.addHappening(date: .now)
                commander.save(event)
            },
            onRemove: { event in
                commander.delete(event)
            },
            onRename: { event, newName in
                event.name = newName
                commander.save(event)
            }
        )
    }
}
