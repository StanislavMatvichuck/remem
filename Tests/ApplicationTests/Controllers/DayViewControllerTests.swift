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
final class DayViewControllerTests: XCTestCase, DayViewControllerTesting {
    var event: Domain.Event!
    var sut: DayViewController!

    override func setUp() {
        super.setUp()
        let day = DayComponents.referenceValue
        let root = CompositionRoot(testingInMemoryMode: true)
        event = Event(name: "Event", dateCreated: day.date)
        sut = root.makeDayViewController(event, day)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_tableViewIsConfigured() {
        XCTAssertNotNil(sut.viewRoot.happenings.dataSource)
        XCTAssertNotNil(sut.viewRoot.happenings.delegate)
    }

    func test_hasTitle() {
        let numberString = sut.title!.split(separator: " ").first
        let wordString = sut.title!.split(separator: " ").last

        XCTAssertNotNil(Int(numberString!))
        XCTAssertLessThanOrEqual(3, wordString!.count)
    }

    func test_hasEditButton() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertEqual(editButton?.title, String(localizationId: "button.edit"))
    }

    func test_editButtonTap_enablesEditMode() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)

        XCTAssertTrue(sut.viewRoot.happenings.isEditing)
    }

    func test_editButtonTap_tapAgain_disablesEditMode() {
        let editButton = sut.navigationItem.rightBarButtonItem

        XCTAssertFalse(sut.viewRoot.happenings.isEditing, "precondition")

        tap(editButton!)
        tap(editButton!)

        XCTAssertFalse(sut.viewRoot.happenings.isEditing)
    }

    func test_hasCreateButton() {
        let createButton = sut.navigationItem.leftBarButtonItem

        XCTAssertEqual(createButton?.title, String(localizationId: "button.create"))
    }

    func test_createButtonTap_presentsAlert() {
        let verifier = AlertVerifier()
        let createButton = sut.navigationItem.leftBarButtonItem

        tap(createButton!)

        verifier.verify(
            title: String(localizationId: "button.create"),
            message: "",
            animated: true,
            actions: [
                .cancel(String(localizationId: "button.cancel")),
                .default(String(localizationId: "button.create"))
            ]
        )
    }

    func test_empty_showsNothing() {
        XCTAssertEqual(sut.happeningsAmount, 0)
    }

    func test_singleHappening_showsTime() {
        addHappening(at: DayComponents.referenceValue.date)
        sendEventUpdatesToController()

        assertCellHasTimeText(at: sut.firstIndex)
    }

    func test_singleHappening_hasSwipeToDelete() {
        addHappening(at: DayComponents.referenceValue.date)
        sendEventUpdatesToController()

        let configuration = sut.table.delegate?.tableView?(
            sut.table,
            trailingSwipeActionsConfigurationForRowAt: sut.firstIndex
        )

        XCTAssertEqual(
            configuration?.actions.first?.title,
            String(localizationId: "button.delete")
        )
    }

    /// Might be refactored with next method
    func test_singleHappening_swipedToDelete_removesHappeningFromList() {
        let date = DayComponents.referenceValue.date
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 0)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 1)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 2)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 3)))
        addHappening(at: date.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 4)))
        sendEventUpdatesToController()

        XCTAssertEqual(sut.happeningsAmount, 1, "precondition")

        let configuration = sut.table.delegate?.tableView?(
            sut.table,
            trailingSwipeActionsConfigurationForRowAt: sut.firstIndex
        )

        let action = configuration!.actions.first!
        action.handler(action, UIView()) { _ in }

        XCTAssertEqual(sut.happeningsAmount, 0)
    }

    func test_manyHappenings_showsManyHappenings() {
        let date = DayComponents.referenceValue.date
        addHappening(at: date.addingTimeInterval(1))
        addHappening(at: date.addingTimeInterval(2))
        addHappening(at: date.addingTimeInterval(3))
        sendEventUpdatesToController()

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: sut.firstIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
    }

    /// Bad test because of viewModel implementation detail
    // TODO: make integration test for picker
    func test_createHappeningAlertShown_swipingPicker_updatesTimeText() {
        tap(sut.navigationItem.leftBarButtonItem!)

        sut.viewModel.update(pickerDate: DayComponents.referenceValue.date)

        XCTAssertEqual(sut.timeInput.text, "00:00")
    }

    func test_createHappeningAlertShown_initialTimeIsStartOfDay() {
        tap(sut.navigationItem.leftBarButtonItem!)

        XCTAssertEqual(sut.timeInput.text!.count, 5)
    }

    private func assertCellHasTimeText(
        at index: IndexPath,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let cell = sut.happening(at: index)
        XCTAssertNotNil(cell.label.text?.firstIndex(of: ":"), file: file, line: line)
        XCTAssertLessThanOrEqual(5, cell.label.text?.count ?? 0, file: file, line: line)
    }
}
