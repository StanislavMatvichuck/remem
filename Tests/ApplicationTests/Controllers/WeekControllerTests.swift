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

    func test_tap_presentsDayController() {
        addPresentationSpy()

        let collection = sut.viewRoot.collection
        let firstCellIndex = IndexPath(row: 0, section: 0)

        collection.delegate?.collectionView?(
            collection,
            didSelectItemAt: firstCellIndex
        )

        spy.verify(animated: true)
    }

    func test_firstDayIsMonday() {
        let firstCellIndex = IndexPath(row: 0, section: 0)

        XCTAssertEqual(dayOfWeek(at: firstCellIndex), WeekDay.monday)
    }

    func test_lastDayIsSunday() {
        let daysCount = sut.viewModel.weekCellViewModels.count
        let lastCellIndex = IndexPath(row: daysCount - 1, section: 0)

        XCTAssertEqual(dayOfWeek(at: lastCellIndex), WeekDay.sunday)
    }

    func test_hasTodayDay() {
        let todays = sut.viewModel.weekCellViewModels.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_todayDay_visibleWhenAppears() throws {
        let happeningOffset = TimeInterval(60 * 60)

        let event = Event(name: "Event", dateCreated: DayComponents.referenceValue.date)
        event.addHappening(date: DayComponents.referenceValue.date.addingTimeInterval(happeningOffset))

        let useCase = EventEditUseCasingFake()
        let coordinator = ApplicationFactory().makeCoordinator()
        self.coordinator = coordinator

        sut = WeekController(
            today: DayComponents.referenceValue.adding(components: DateComponents(year: 1)),
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )

        layoutInScreen()

        let visibleCells = sut.viewRoot.collection.visibleCells
        let visibleDays = try XCTUnwrap(visibleCells as? [WeekCell])
        let todayCell = visibleDays.filter { $0.viewModel.isToday }

        XCTAssertEqual(todayCell.count, 1)
    }

    func test_firstDay_showsDayNumber() {
        XCTAssertEqual(sut.firstDay.day.text, "1")
    }

    func test_hasHappening_firstDayShowsHappeningTime() {
        let happeningOffset = TimeInterval(60 * 60)

        let event = Event(
            id: "",
            name: "Event",
            happenings: [],
            dateCreated: DayComponents.referenceValue.date,
            dateVisited: nil
        )

        event.addHappening(date: DayComponents.referenceValue.date.addingTimeInterval(happeningOffset))

        let useCase = EventEditUseCasingFake()

        let coordinator = ApplicationFactory().makeCoordinator()
        self.coordinator = coordinator

        let sut = WeekController(
            today: DayComponents.referenceValue,
            event: event,
            useCase: useCase,
            coordinator: coordinator
        )

        XCTAssertEqual(sut.firstDay.timingLabels.first?.text, "01:00")
    }

    private func dayOfWeek(at index: IndexPath) -> WeekDay? {
        let day = sut.day(at: index)

        let dayOfWeekNumber = Calendar.current.dateComponents(
            [.weekday],
            from: day.viewModel.day.date
        ).weekday ?? 0

        return WeekDay(rawValue: dayOfWeekNumber)
    }

    private func addPresentationSpy() {
        spy = PresentationVerifier()
    }

    private func layoutInScreen() {
        putInViewHierarchy(sut)
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }
}
