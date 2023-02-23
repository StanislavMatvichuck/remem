//
//  DayControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import ViewControllerPresentationSpy
import XCTest

@MainActor
final class DayDetailsViewControllerTests: XCTestCase, TestingViewController {
    var sut: DayDetailsViewController!
    var event: Event!
    var commander: EventsCommanding!

    override func setUp() {
        super.setUp()
        make()
    }

    override func tearDown() {
        super.tearDown()
        clear()
    }

    func test_tableIsConfigured() {
        XCTAssertNotNil(sut.viewRoot.happenings.dataSource)
        XCTAssertNotNil(sut.viewRoot.happenings.delegate)
    }

    func test_showsTitle() {
        let numberString = sut.title!.split(separator: " ").first
        let wordString = sut.title!.split(separator: " ").last

        XCTAssertNotNil(Int(numberString!))
        XCTAssertLessThanOrEqual(3, wordString!.count)
    }

    func test_showsEditButton() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertEqual(editButton?.title, String(localizationId: "button.edit"))
    }

    func test_editButtonTapped_editModeEnabled() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)

        XCTAssertTrue(sut.viewRoot.happenings.isEditing)
    }

    func test_editButtonTappedTwoTimes_editModeDisabled() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)
        tap(editButton!)

        XCTAssertFalse(sut.viewRoot.happenings.isEditing)
    }

    func test_showsCreateHappeningButton() {
        let createButton = sut.navigationItem.leftBarButtonItem

        XCTAssertEqual(createButton?.title, String(localizationId: "button.addHappening"))
    }

    func test_createButtonTaped_createHappeningAlertPresented() {
        let verifier = AlertVerifier()
        let createButton = sut.navigationItem.leftBarButtonItem

        tap(createButton!)

        verifier.verify(
            title: String(localizationId: "button.addHappening"),
            message: "",
            animated: true,
            actions: [
                .cancel(String(localizationId: "button.cancel")),
                .default(String(localizationId: "button.addHappening"))
            ]
        )
    }

    func test_empty_noHappeningsInList() {
        XCTAssertEqual(happeningsAmount, 0)
    }

    func test_singleHappening_showsTime() {
        addHappening(at: DayIndex.referenceValue.date)
        sendEventUpdatesToController()

        assertCellHasTimeText(at: firstIndex)
    }

    func test_singleHappening_hasSwipeToDelete() {
        addHappening(at: DayIndex.referenceValue.date)
        sendEventUpdatesToController()

        let configuration = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: firstIndex
        )

        XCTAssertEqual(
            configuration?.actions.first?.title,
            String(localizationId: "button.delete")
        )
    }

    /// Might be refactored with next method
    func test_singleHappening_swipedToDelete_removesHappeningFromList() {
        let date = DayIndex.referenceValue.date
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 0)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 1)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 2)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 3)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 4)))
        sendEventUpdatesToController()

        XCTAssertEqual(happeningsAmount, 1, "precondition")

        let configuration = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: firstIndex
        )

        let action = configuration!.actions.first!
        action.handler(action, UIView()) { _ in }

        XCTAssertEqual(happeningsAmount, 0)
    }

    func test_manyHappenings_showsManyHappenings() {
        let date = DayIndex.referenceValue.date
        addHappening(at: date.addingTimeInterval(1))
        addHappening(at: date.addingTimeInterval(2))
        addHappening(at: date.addingTimeInterval(3))
        sendEventUpdatesToController()

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: firstIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
    }

    /// Bad test because of viewModel implementation detail
    // TODO: make integration test for picker
    func test_createHappeningAlertPresented_scrollingPicker_updatesTimeText() {
        tap(sut.navigationItem.leftBarButtonItem!)

        sut.viewModel.update(pickerDate: DayIndex.referenceValue.date)

        XCTAssertEqual(sut.timeInput.text, "00:00")
    }

    func test_createHappeningAlertPresented_initialTimeIsStartOfDay() {
        tap(sut.navigationItem.leftBarButtonItem!)

        XCTAssertEqual(sut.timeInput.text!.count, 5)
    }

    private func assertCellHasTimeText(
        at index: IndexPath,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let cell = happening(at: index)
        XCTAssertNotNil(cell.label.text?.firstIndex(of: ":"), file: file, line: line)
        XCTAssertLessThanOrEqual(5, cell.label.text?.count ?? 0, file: file, line: line)
    }
}
