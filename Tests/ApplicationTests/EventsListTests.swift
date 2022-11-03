//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import IosUseCases
import XCTest

class EmptyEventsListControllerTests: XCTestCase {
    private var sut: EventsListController!

    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoad_hasTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_viewDidLoad_tableIsConfigured() throws {
        XCTAssertNotNil(view.table.dataSource)
        XCTAssertNotNil(view.table.delegate)
    }

    func test_viewDidLoad_tableHasThreeSections() throws {
        XCTAssertEqual(
            view.table.numberOfSections,
            EventsListController.Section.allCases.count
        )

        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.hint.rawValue), 1)
        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.events.rawValue), 0)
        XCTAssertEqual(view.table.numberOfRows(inSection: EventsListController.Section.footer.rawValue), 1)
    }

    func test_viewDidLoad_rendersEmptyHint() throws {
        let hintText = try hintText()

        XCTAssertEqual(hintText, String(localizationId: "eventsList.hint.empty"))
    }

    func test_viewDidLoad_gestureHintIsNotVisible() {
        let gestureHint = view.swipeHint

        XCTAssertNil(gestureHint.superview)
    }

    func test_viewDidLoad_rendersAddButton() throws {
        let button = try addButton()
        let buttonText = (button.subviews.first as! UILabel).text

        XCTAssertEqual(buttonText, "+")
        XCTAssertEqual(button.backgroundColor?.cgColor, UIHelper.brand.cgColor)
    }
}

// MARK: - Private
private extension EmptyEventsListControllerTests {
    func makeSUT() -> EventsListController {
        let view = EventsListView()
        let viewModel = EventsListViewModelFake()
        let sut = EventsListController(viewRoot: view, viewModel: viewModel)
        sut.loadViewIfNeeded()
        return sut
    }

    var view: EventsListView { sut.view as! EventsListView }

    func hintText() throws -> String? {
        let index = IndexPath(row: 0, section: EventsListController.Section.hint.rawValue)
        let hintCell = try XCTUnwrap(cell(at: index) as? EventsListHintCell)
        return hintCell.label.text
    }

    func addButton() throws -> UIView {
        let index = IndexPath(row: 0, section: EventsListController.Section.footer.rawValue)
        let footerCell = try XCTUnwrap(cell(at: index) as? EventsListFooterCell)
        return footerCell.buttonAdd
    }

    func cell(at indexPath: IndexPath) -> UITableViewCell? {
        let table = view.table
        let dataSource = table.dataSource
        return dataSource?.tableView(table, cellForRowAt: indexPath)
    }
}

class EventsListViewModelFake: EventsListViewModeling {
    init() {}

    func select(event: Domain.Event) {}
    func selectForRenaming(event: Domain.Event) {}
    func selectForRemoving(event: Domain.Event) {}
    func cancelNameEditing() {}
    func submitNameEditing(name: String) {}

    var isAddButtonHighlighted: Bool = true
    var hint: Application.HintState = .empty
    var count: Int = 0

    func event(at: Int) -> Domain.Event? {
        nil
    }

    func cellVM(at: Int) -> Application.EventCellViewModel? {
        nil
    }
}
