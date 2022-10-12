//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import IosUseCases
import XCTest

class EventsListTests: XCTestCase {
    func testInit() throws {
        let sut = try makeSUT()
        XCTAssertNotNil(sut)
    }

    func test_viewDidLoad_rendersTitle() throws {
        let sut = try makeSUT()
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_viewDidLoad_tableIsConfigured() throws {
        let sut = try makeSUT()

        let view = try XCTUnwrap(sut.view as? EventsListView)

        XCTAssertNotNil(view.table.dataSource)
        XCTAssertNotNil(view.table.delegate)
    }

    func test_viewDidLoad_hasThreeSections() throws {
        let sut = try makeSUT()

        let view = try XCTUnwrap(sut.view as? EventsListView)

        XCTAssertEqual(view.table.numberOfSections, 3)
        XCTAssertEqual(view.table.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(view.table.numberOfRows(inSection: 1), 0)
        XCTAssertEqual(view.table.numberOfRows(inSection: 2), 1)
    }

    func test_viewDidLoad_rendersEmptyHint() throws {
        let sut = try makeSUT()

        let view = try XCTUnwrap(sut.view as? EventsListView)
        let cellIndex = IndexPath(row: 0, section: 0)
        let hintCell = try XCTUnwrap(view.table.cellForRow(at: cellIndex) as? EventsListHintCell)

        XCTAssertEqual(hintCell.label.text, String(localizationId: "eventsList.hint.empty"))
    }
}

private extension EventsListTests {
    func makeSUT() throws -> EventsListController {
        let applicationFactory = ApplicationFactory(inMemory: true)
        let rootController = applicationFactory.makeRootViewController()

        let navigationVC = try XCTUnwrap(rootController as? UINavigationController)
        let eventsListVC = try XCTUnwrap(navigationVC.viewControllers[0] as? EventsListController)
        eventsListVC.loadViewIfNeeded()

        return eventsListVC
    }
}
