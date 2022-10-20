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
        let view = try getView(of: sut)

        XCTAssertNotNil(view.table.dataSource)
        XCTAssertNotNil(view.table.delegate)
    }

    func test_viewDidLoad_hasThreeSections() throws {
        let sut = try makeSUT()
        let view = try getView(of: sut)

        XCTAssertEqual(view.table.numberOfSections, EventsListController.Section.allCases.count)
        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.hint.rawValue), 1)
        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.events.rawValue), 0)
        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.footer.rawValue), 1)
    }

    func test_viewDidLoad_rendersEmptyHint() throws {
        let sut = try makeSUT()
        let view = try getView(of: sut)
        let hintText = try hintText(of: view)

        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_viewDidLoad_gestureHintIsNotVisible() throws {
        let sut = try makeSUT()
        let gestureHint = try getView(of: sut).swipeHint

        XCTAssertNil(gestureHint.superview)
    }

    func test_viewDidLoad_rendersAddButton() throws {
        let sut = try makeSUT()
        let view = try getView(of: sut)
        let button = try addButton(of: view)
        let buttonText = (button.subviews.first as! UILabel).text

        XCTAssertEqual(buttonText, "+")
        XCTAssertEqual(button.backgroundColor?.cgColor, UIHelper.brand.cgColor)
    }
}

private extension EventsListTests {
    func makeSUT() throws -> EventsListController {
        let scene = UIApplication.shared.connectedScenes.first
        let windowScene = try XCTUnwrap(scene as? UIWindowScene)
        let window = windowScene.keyWindow

        let navigationVC = try XCTUnwrap(window?.rootViewController as? UINavigationController)
        let eventsListVC = try XCTUnwrap(navigationVC.viewControllers[0] as? EventsListController)
        eventsListVC.loadViewIfNeeded()

        return eventsListVC
    }

    func getView(of controller: EventsListController) throws -> EventsListView {
        let view = try XCTUnwrap(controller.view as? EventsListView)
        return view
    }

    func hintText(of view: EventsListView) throws -> String? {
        let index = IndexPath(row: 0, section: EventsListController.Section.hint.rawValue)
        let hintCell = try XCTUnwrap(cell(of: view, at: index) as? EventsListHintCell)
        return hintCell.label.text
    }

    func addButton(of view: EventsListView) throws -> UIView {
        let index = IndexPath(row: 0, section: EventsListController.Section.footer.rawValue)
        let footerCell = try XCTUnwrap(cell(of: view, at: index) as? EventsListFooterCell)
        return footerCell.buttonAdd
    }

    func cell(of view: EventsListView, at indexPath: IndexPath) -> UITableViewCell? {
        let table = view.table
        let dataSource = table.dataSource
        return dataSource?.tableView(table, cellForRowAt: indexPath)
    }
}
