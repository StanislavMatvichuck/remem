//
//  HoursCircleContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

@testable import Application
import XCTest

final class HoursCircleContainerTests: XCTestCase {
    private weak var weakSUT: HoursCircleContainer?

    func test_makeController_hasNoReferenceCycles() {
        var sut: HoursCircleContainer? = HoursCircleContainer(EventDetailsContainer.makeForUnitTests())
        weakSUT = sut

        var controller: HoursCircleController? = sut?.makeHoursCircleController()
        controller?.loadViewIfNeeded()

        controller = nil
        sut = nil

        XCTAssertNil(weakSUT)
    }
}
