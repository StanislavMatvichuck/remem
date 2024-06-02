//
//  EventsSorterManualRepository.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.01.2024.
//

import DataLayer
import Domain
import XCTest

final class EventsSorterManualRepositoryTests: XCTestCase {
    private var sut: (ManualEventsOrderingReading & ManualEventsOrderingWriting)!

    override func setUp() {
        super.setUp()
        sut = EventsSorterManualRepository(
            LocalFile.testingEventsQueryManualSorter
        )
    }

    override func tearDown() {
        sut = nil
        do { try FileManager().removeItem(at: LocalFile.testingEventsQueryManualSorter.url) } catch {
            print("cannot delete")
        }
        super.tearDown()
    }

    func test_init_requiresURLProviding() { XCTAssertNotNil(sut) }
    func test_get_empty() { XCTAssertEqual(sut.get(), []) }
    func test_set_acceptsArrayOfStrings() { sut.set(["A", "B"]) }

    func test_get_afterSettingAB_AB() {
        sut.set(["A", "B"])

        XCTAssertEqual(sut.get(), ["A", "B"])
    }
}
