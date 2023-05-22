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
final class WeekViewControllerTests: XCTestCase, TestingViewController {
    var spy: PresentationVerifier!
    var sut: WeekViewController!
    var event: Event!
    var commander: EventsCommanding!

    override func setUp() {
        super.setUp()
        make()
    }

    override func tearDown() {
        clear()
        super.tearDown()
    }

    func test_tap_presentsDayController() {
        addPresentationSpy()

        let collection = sut.viewRoot.collection
        let firstCellIndex = IndexPath(row: 0, section: 0)

        putInViewHierarchy(sut)
        sut.viewRoot.layoutIfNeeded()

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
        let daysCount = sut.viewModel.timeline.count
        let lastCellIndex = IndexPath(row: daysCount - 1, section: 0)

        XCTAssertEqual(dayOfWeek(at: lastCellIndex), WeekDay.sunday)
    }

    func test_hasTodayDay() {
        let todays = sut.viewModel.timeline.filter { ($0?.isToday)! }

        XCTAssertEqual(todays.count, 1)
    }

    func test_todayDay_visibleWhenAppears() throws {
        /// Random numbers may be replaced with cycle but then it takes significant time to execute
        let createdRandomOffset = Int.random(in: 0 ..< 1000)
        let todayRandomOffset = Int.random(in: 0 ..< 1000)

        let created = DayIndex.referenceValue.adding(dateComponents: DateComponents(day: createdRandomOffset))
        let event = Event(name: "Event", dateCreated: created.date)
        let today = created.adding(dateComponents: DateComponents(day: todayRandomOffset))

        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = WeekContainer(parent: container).make() as? WeekViewController

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
            let weekCell = try XCTUnwrap(cell as? WeekCell)
            return weekCell.viewModel!.isToday
        }

        XCTAssertEqual(todayCell.count, 1)
    }

    func test_firstDay_showsDayNumber() {
        XCTAssertEqual(firstDay.view.day.text, "1")
    }

    func test_hasHappening_firstDayShowsHappeningTime() {
        let today = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)

        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = WeekContainer(parent: container).make() as? WeekViewController
        sut.loadViewIfNeeded()

        XCTAssertEqual(firstDay.view.timingLabels.first?.text, "00:00")
    }

    func test_showsWeekSummary() {
        sut.viewDidLayoutSubviews()
        XCTAssertEqual(sut.viewRoot.goal.amount.text, "0")
    }

    func test_eventWithOneHappening_weekSummary_1() {
        event.addHappening(date: DayIndex.referenceValue.adding(days: 0).date)

        sendEventUpdatesToController()

        XCTAssertEqual(sut.viewRoot.goal.amount.text, "1")
    }

    func test_eventWithHappeningEachDayOfWeek_weekSummary_7() {
        event.addHappening(date: DayIndex.referenceValue.adding(days: 0).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 1).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 2).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 3).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 4).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 5).date)
        event.addHappening(date: DayIndex.referenceValue.adding(days: 6).date)

        sendEventUpdatesToController()

        XCTAssertEqual(sut.viewRoot.goal.amount.text, "7")
    }

    private func dayOfWeek(at index: IndexPath) -> WeekDay? {
        let vm = sut.viewModel.timeline[index.row]!

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
