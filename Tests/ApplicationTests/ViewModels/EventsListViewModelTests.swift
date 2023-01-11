//
//  EventsListViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.12.2022.
//

@testable import Application
import Domain
import XCTest

class EventsListViewModelTests: XCTestCase {
    func test_hasNumberOfSections() {
        let sut = CompositionRoot(testingInMemoryMode: true).makeEventsListViewModel()

        XCTAssertEqual(sut.numberOfSections, 3)
    }
}
