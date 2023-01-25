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

@MainActor
class WeekViewControllerTests: XCTestCase, WeekViewControllerTesting {
    var spy: PresentationVerifier!
    var sut: WeekViewController!
    var event: Event!
    var viewModelFactory: WeekViewModelFactoring!

    override func setUp() {
        super.setUp()
        makeSutWithViewModelFactory()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        clearSutAndViewModelFactory()
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
        let daysCount = sut.viewModel.items.count
        let lastCellIndex = IndexPath(row: daysCount - 1, section: 0)

        XCTAssertEqual(dayOfWeek(at: lastCellIndex), WeekDay.sunday)
    }

    func test_hasTodayDay() {
        let todays = sut.viewModel.items.filter { $0.isToday }

        XCTAssertEqual(todays.count, 1)
    }

    func test_todayDay_visibleWhenAppears() throws {
        /// Random numbers may be replaced with cycle but then it takes significant time to execute
        let createdRandomOffset = Int.random(in: 0 ..< 1000)
        let todayRandomOffset = Int.random(in: 0 ..< 1000)

        let created = DayComponents.referenceValue.adding(components: DateComponents(day: createdRandomOffset))
        let event = Event(name: "Event", dateCreated: created.date)
        let today = created.adding(components: DateComponents(day: todayRandomOffset))

        sut = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
            .makeWeekViewController()

        layoutInScreen()

        let collection = sut.viewRoot.collection
        let renderedIndexPaths = collection.indexPathsForVisibleItems
        let fullyVisibleIndexPaths = renderedIndexPaths.filter { indexPath in
            let layoutAttribute = collection.layoutAttributesForItem(at: indexPath)!
            let cellFrame = layoutAttribute.frame
            let isCellFullyVisible =
                cellFrame.minX >= collection.bounds.minX &&
                cellFrame.maxX.rounded(.down) <= collection.bounds.maxX
            return isCellFullyVisible
        }

        let todayCell = try fullyVisibleIndexPaths.filter { index in
            let cell = collection.cellForItem(at: index)
            let weekCell = try XCTUnwrap(cell as? WeekItem)
            return weekCell.viewModel.isToday
        }

        XCTAssertEqual(todayCell.count, 1)
    }

    func test_firstDay_showsDayNumber() {
        XCTAssertEqual(sut.firstDay.day.text, "1")
    }

    func test_hasHappening_firstDayShowsHappeningTime() {
        let today = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: DayComponents.referenceValue.date)
        event.addHappening(date: DayComponents.referenceValue.date)

        sut = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
            .makeWeekViewController()

        XCTAssertEqual(sut.firstDay.timingLabels.first?.text, "00:00")
    }

    private func dayOfWeek(at index: IndexPath) -> WeekDay? {
        let vm = sut.viewModel.items[index.row]

        let dayOfWeekNumber = Calendar.current.dateComponents(
            [.weekday],
            from: vm.date
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
