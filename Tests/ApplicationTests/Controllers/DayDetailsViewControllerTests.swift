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

class DayDetailsViewControllerTests: XCTestCase {
    var sut: DayDetailsViewController!

    override func setUp() {
        super.setUp()
        sut = DayDetailsViewController.make()
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
        let event = Event(name: "EventWithOneHappening")
        event.addHappening(date: .now)

        sut = DayDetailsViewController.make(event: event)

        assertCellHasTimeText(at: sut.firstIndex)
    }

    func test_singleHappening_hasSwipeToDelete() {
        let event = Event(name: "EventWithOneHappening")
        event.addHappening(date: .now)

        sut = DayDetailsViewController.make(event: event)

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
        let event = Event(name: "EventWithOneHappening")
        event.addHappening(date: .now.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 0)))
        event.addHappening(date: .now.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 1)))
        event.addHappening(date: .now.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 2)))
        event.addHappening(date: .now.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 3)))
        event.addHappening(date: .now.addingTimeInterval(-TimeInterval(60 * 60 * 24 * 4)))

        sut = DayDetailsViewController.make(event: event)

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
        let event = Event(name: "EventWithThreeHappenings")
        event.addHappening(date: .now.addingTimeInterval(-1))
        event.addHappening(date: .now.addingTimeInterval(-2))
        event.addHappening(date: .now.addingTimeInterval(-3))

        sut = DayDetailsViewController.make(event: event)

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: sut.firstIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
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
