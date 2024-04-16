//
//  DayCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 10.01.2024.
//

@testable import Application
import Domain
import XCTest

final class DayCellViewModelTests: XCTestCase {
    func test_time_happeningAtStart_0000() {
        let sut = DayCellViewModel(
            id: UUID().uuidString,
            happening: Happening(dateCreated: DayIndex.referenceValue.date)
        )

        XCTAssertEqual(sut.time, "00:00")
    }
}
