//
//  EventsSorterRepositoryTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import DataLayer
import Domain
import XCTest

final class EventsSorterRepositoryTests: XCTestCase {
    private var sut: (EventsOrderingReading & EventsOrderingWriting)!

    override func setUp() {
        super.setUp()
        sut = EventsSorterRepository(
            LocalFile.testingEventsQuerySorter
        )
    }

    override func tearDown() {
        sut = nil
        do { try FileManager().removeItem(at: LocalFile.testingEventsQuerySorter.url) } catch {}
        super.tearDown()
    }

    func test_init_requiresURLProviding() {
        XCTAssertNotNil(sut)
    }

    func test_get_name() {
        XCTAssertEqual(sut.get(), EventsList.Ordering.name)
    }

    func test_set_acceptsSorter() {
        sut.set(.total)
    }

    func test_get_afterSettingHappeningsCount_happeningsCount() {
        sut.set(.total)

        XCTAssertEqual(sut.get(), .total)
    }
}
