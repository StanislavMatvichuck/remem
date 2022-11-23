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

class DayControllerTests: XCTestCase {
    var sut: DayController!

    override func setUp() {
        super.setUp()
        sut = makeSut()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_tableViewIsConfigured() {
        XCTAssertNotNil(sut.viewRoot.happenings.dataSource)
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
        XCTAssertEqual(sut.viewRoot.happenings.numberOfRows(inSection: 0), 0)
    }

    func test_oneHappening_showsFirstHappeningTime() {
        let event = Event(name: "EventWithOneHappening")
        event.addHappening(date: .now)

        sut = makeSut(event: event)

        assertCellHasTimeText(at: sut.firstCellIndex)
    }

    func test_manyHappenings_showsFewHappenings() {
        let event = Event(name: "EventWithThreeHappenings")
        event.addHappening(date: .now.addingTimeInterval(-1))
        event.addHappening(date: .now.addingTimeInterval(-2))
        event.addHappening(date: .now.addingTimeInterval(-3))

        sut = makeSut(event: event)

        let secondCellIndex = IndexPath(row: 1, section: 0)
        let thirdCellIndex = IndexPath(row: 2, section: 0)

        assertCellHasTimeText(at: sut.firstCellIndex)
        assertCellHasTimeText(at: secondCellIndex)
        assertCellHasTimeText(at: thirdCellIndex)
    }

    private func makeSut(event: Event = Event(name: "EventName")) -> DayController {
        let useCase = EventEditUseCasingFake()
        let sut = DayController(date: .now, event: event, useCase: useCase)
        sut.loadViewIfNeeded()

        _ = UINavigationController(rootViewController: sut)

        return sut
    }

    private func assertCellHasTimeText(
        at index: IndexPath,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let cell = sut.happening(at: index)
        XCTAssertNotNil(cell?.label.text?.firstIndex(of: ":"), file: file, line: line)
        XCTAssertLessThanOrEqual(5, cell?.label.text?.count ?? 0, file: file, line: line)
    }
}

private extension DayController {
    var table: UITableView { viewRoot.happenings }
    var firstCellIndex: IndexPath { IndexPath(row: 0, section: 0) }

    func happening(at index: IndexPath) -> DayHappeningCell? {
        do {
            let cell = try XCTUnwrap(table.dataSource?.tableView(table, cellForRowAt: index) as? DayHappeningCell)
            return cell
        } catch {
            fatalError("happening getting error")
        }
    }
}
