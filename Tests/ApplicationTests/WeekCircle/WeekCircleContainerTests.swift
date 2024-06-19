//
//  WeekCircleContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

@testable import Application
import XCTest

final class WeekCircleContainerTests: XCTestCase {
    private weak var weakSUT: WeekCircleContainer?

    func test_makeController_hasNoReferenceCycles() {
        var sut: WeekCircleContainer? = WeekCircleContainer(EventDetailsContainer.makeForUnitTests())
        weakSUT = sut

        var controller: WeekCircleController? = sut?.makeWeekCircleController()
        controller?.loadViewIfNeeded()

        controller = nil
        sut = nil

        XCTAssertNil(weakSUT)
    }
}
