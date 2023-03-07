//
//  DependencyContainersTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 05.03.2023.
//

@testable import Application
import XCTest

final class DependencyContainersTests: XCTestCase {
    weak var weakSut: UIViewController?

    func test_eventsListContainer_hasNoCyclingReferences() {
        var vc: EventsListViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_eventDetailsContainer_hasNoCyclingReferences() {
        var vc: EventDetailsViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    override func tearDown() {
        super.tearDown()

        XCTAssertNil(weakSut)
    }

    func test_weekContainer_hasNoCyclingReferences() {
        var vc: WeekViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_clockContainer_hasNoCyclingReferences() {
        var vc: ClockViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_summaryContainer_hasNoCyclingReferences() {
        var vc: SummaryViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }

    func test_dayDetailsContainer_hasNoCyclingReferences() {
        var vc: DayDetailsViewController? = ApplicationContainer.make()
        weakSut = vc

        vc = nil
    }
}
