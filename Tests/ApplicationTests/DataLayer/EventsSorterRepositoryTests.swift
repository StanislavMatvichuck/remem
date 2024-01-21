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
    private var sut: (EventsSortingQuerying & EventsSortingCommanding)!

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

    func test_get_alphabetical() {
        XCTAssertEqual(sut.get(), EventsSorter.alphabetical)
    }

    func test_set_acceptsSorter() {
        sut.set(.happeningsCountTotal)
    }

    func test_get_afterSettingHappeningsCount_happeningsCount() {
        sut.set(.happeningsCountTotal)

        XCTAssertEqual(sut.get(), .happeningsCountTotal)
    }
}
