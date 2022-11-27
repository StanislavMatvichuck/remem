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

        let event = Event(
            id: "",
            name: "Event",
            happenings: [],
            dateCreated: DayComponents.referenceValue.date,
            dateVisited: nil
        )

        let useCase = EventEditUseCasingFake()

        let spy = PresentationVerifier()
        self.spy = spy

        let coordinator = ApplicationFactory().makeCoordinator()
        self.coordinator = coordinator

        let sut = WeekController(
            today: DayComponents.referenceValue,
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

    func test_firstDayIsMonday() throws {
        let firstCellIndex = IndexPath(row: 0, section: 0)

        XCTAssertEqual(dayOfWeek(at: firstCellIndex), WeekDay.monday)
    }

    func test_lastDayIsSunday() throws {
        let daysCount = sut.viewModel.weekCellViewModels.count
        let lastCellIndex = IndexPath(row: daysCount - 1, section: 0)

        XCTAssertEqual(dayOfWeek(at: lastCellIndex), WeekDay.sunday)
    }

    func test_hasTodayDay() {
        let todays = sut.viewModel.weekCellViewModels.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_todayDayIsVisibleWhenAppears() {}
    func test_numberOfDaysDependsOnEventCreationDate() {}

    func test_numberOfDaysIsDividedBy7() {
        let daysCount = sut.viewRoot.collection.numberOfItems(inSection: 0)

        XCTAssertEqual(daysCount % 7, 0)
    }

    func test_numberOfDaysAtLeast21() {
        XCTAssertLessThanOrEqual(
            21,
            sut.viewRoot.collection.numberOfItems(inSection: 0)
        )
    }

    private func dayOfWeek(at index: IndexPath) -> WeekDay? {
        do {
            let collection = sut.viewRoot.collection
            let cell = collection.dataSource?.collectionView(collection, cellForItemAt: index)
            let dayCell = try XCTUnwrap(cell as? WeekCell)
            let dayOfWeekNumber = Calendar.current.dateComponents(
                [.weekday],
                from: dayCell.viewModel.day.date
            ).weekday ?? 0

            return WeekDay(rawValue: dayOfWeekNumber)
        } catch { return nil }
    }
}
