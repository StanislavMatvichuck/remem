//
//  WeekControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

class WeekControllerTests: XCTestCase {
    var spy: PresentationVerifier!
    var sut: WeekController!
    var coordinator: Coordinating!

    override func setUp() {
        super.setUp()

        let event = Event(name: "Event")
        let useCase = EventEditUseCasingFake()

        let spy = PresentationVerifier()
        self.spy = spy

        let coordinator = ApplicationFactory().makeCoordinator()
        self.coordinator = coordinator

        let sut = WeekController(
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )

        self.sut = sut
    }

    override func tearDown() {
        spy = nil
        sut = nil
        coordinator = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_tap_presentsDayController() throws {
        let collection = sut.viewRoot.collection
        let firstCellIndex = IndexPath(row: 0, section: 0)

        collection.delegate?.collectionView?(
            collection,
            didSelectItemAt: firstCellIndex
        )

        spy.verify(animated: true)
    }

    func test_firstDayIsMonday() {}
    func test_lastDayIsSunday() {}
    func test_hasTodayDay() {
        let todays = sut.viewModel.weekCellViewModels.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_todayDayIsVisible() {}
    func test_numberOfDaysDependsOnEventCreationDate() {}
    func test_numberOfDaysIsDividedBy7() {}
    func test_numberOfDaysAtLeast21() {
        XCTAssertLessThanOrEqual(
            21,
            sut.viewRoot.collection.numberOfItems(inSection: 0)
        )
    }
}
