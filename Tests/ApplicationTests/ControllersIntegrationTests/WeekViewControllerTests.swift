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

    var buttonPlus: UIButton { sut.viewRoot.goal.accessory.plus }
    var buttonMinus: UIButton { sut.viewRoot.goal.accessory.minus }

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
        let daysCount = sut.viewModel.timelineCount
        let lastCellIndex = IndexPath(row: daysCount - 1, section: 0)

        XCTAssertEqual(dayOfWeek(at: lastCellIndex), WeekDay.sunday)
    }

    func test_hasTodayDayAndOnlyOne() {
        var todaysFound = 0

        for i in 0 ... sut.viewModel.timelineCount {
            let weekCellViewModel = sut.viewModel.weekCellFactory.makeViewModel(
                indexPath: IndexPath(row: i, section: 0),
                cellPresentationAnimationBlock: {},
                cellDismissAnimationBlock: {}
            )
            if weekCellViewModel.isToday {
                todaysFound += 1
            }
        }

        XCTAssertEqual(todaysFound, 1)
    }

    private var randomDaysAmount: Int { Int.random(in: 0 ..< 1000) }

//    func test_todayDay_visibleWhenAppears() throws {
//        /// Random numbers may be replaced with cycle but then it takes significant time to execute
//        let created = DayIndex.referenceValue.adding(days: randomDaysAmount)
//
//        let event = Event(name: "Event", dateCreated: created.date)
//
//        sut = WeekContainer(
//            EventDetailsContainer(
//                EventsListContainer(
//                    ApplicationContainer(mode: .unitTest)
//                ),
//                event: event
//            )).make() as! WeekViewController
//
//        layoutInScreen()
//
//        XCTAssertEqual(try todayVisibleIndexPaths().count, 1)
//    }

    func test_firstDay_showsDayNumber() {
        XCTAssertEqual(firstDay.view.day.text, "1")
    }

    func test_hasHappening_firstDayShowsHappeningTime() {
        let today = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)

        let container = WeekContainer(
            EventDetailsContainer(
                EventsListContainer(
                    ApplicationContainer(mode: .unitTest)
                ), event: event
            ))
        sut = container.make() as? WeekViewController
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

    // MARK: - Accessory button plus
    func test_noGoal_buttonPlusTapped_setsGoalToOne() {
        tap(buttonPlus)

        XCTAssertEqual(sut.viewRoot.goal.goal.text, "1")
    }

    func test_goalIsOne_buttonPlusTapped_setsGoalToTwo() {
        arrangeEventWithGoalOf(1)

        tap(buttonPlus)

        XCTAssertEqual(sut.viewRoot.goal.goal.text, "2")
    }

    // MARK: - Accessory button minus
    func test_noGoal_buttonMinusTapped_nothingHappens() {
        XCTAssertEqual(sut.viewRoot.goal.goal.text, "")

        tap(buttonMinus)

        XCTAssertEqual(sut.viewRoot.goal.goal.text, "")
    }

    func test_goalIsOne_buttonMinusTapped_nothingHappens() {
        arrangeEventWithGoalOf(1)

        tap(buttonMinus)

        XCTAssertEqual(sut.viewRoot.goal.goal.text, "1")
    }

    func test_goalIsTwo_buttonMinusTapped_setsGoalToOne() {
        arrangeEventWithGoalOf(2)

        tap(buttonMinus)

        XCTAssertEqual(sut.viewRoot.goal.goal.text, "1")
    }

    // MARK: - Private
    private func dayOfWeek(at index: IndexPath) -> WeekDay? {
        let vm = sut.viewModel.weekCellFactory.makeViewModel(
            indexPath: index,
            cellPresentationAnimationBlock: {},
            cellDismissAnimationBlock: {}
        )

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
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.addSubview(sut.view)
        sut.view.layoutIfNeeded()
    }

    private func fullyVisibleIndexPaths() -> [IndexPath] {
        let collection = sut.viewRoot.collection
        let renderedIndexPaths = collection.indexPathsForVisibleItems
        return renderedIndexPaths.filter { indexPath in
            let layoutAttribute = collection.layoutAttributesForItem(at: indexPath)!
            let cellFrame = layoutAttribute.frame
            let isCellFullyVisible =
                cellFrame.minX >= collection.bounds.minX &&
                cellFrame.maxX.rounded(.down) <= collection.bounds.maxX
            return isCellFullyVisible
        }
    }

    private func todayVisibleIndexPaths() throws -> [IndexPath] {
        try fullyVisibleIndexPaths().filter { index in
            let cell = sut.viewRoot.collection.cellForItem(at: index)
            let weekCell = try XCTUnwrap(cell as? WeekCell)
            return weekCell.viewModel!.isToday
        }
    }

    private func arrangeEventWithGoalOf(
        _ goalAmount: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        event.setWeeklyGoal(amount: goalAmount, for: event.dateCreated)
        sendEventUpdatesToController()

        XCTAssertEqual(sut.viewRoot.goal.goal.text, String(goalAmount), file: file, line: line)
    }
}
