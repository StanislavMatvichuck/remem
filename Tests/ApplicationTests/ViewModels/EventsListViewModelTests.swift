//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import Domain
import XCTest

final class EventsListViewModelTests: XCTestCase {
    func test_hasNumberOfSections() {
        let sut = EventsListViewModel(
            today: DayComponents.referenceValue,
            commander: EventsCommandingStub(),
            sections: [[], [], []]
        )

        XCTAssertEqual(sut.numberOfSections, 3)
    }
}
