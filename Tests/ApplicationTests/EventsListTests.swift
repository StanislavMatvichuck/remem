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

class EmptyEventsListControllerTests:
    XCTestCase,
    EventsListControllerTestsHelpers
{
    var sut: EventsListController!

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

    func test_viewDidLoad_rendersEmptyHint() {
        XCTAssertEqual(hintText(), String(localizationId: "eventsList.hint.empty"))
    }

    func test_viewDidLoad_gestureHintIsNotVisible() {
        let gestureHint = view.swipeHint

        XCTAssertNil(gestureHint.superview)
    }

    func test_viewDidLoad_rendersHighlightedAddButton() throws {
        let button = try addButton()

        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        XCTAssertEqual(button.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertTrue(button.isHighlighted, "Button must be highlighted when list is empty")
    }

    func test_addButtonTapped_keyboardShown() throws {
        putInViewHierarchy(sut)

        XCTAssertFalse(view.input.input.isFirstResponder, "precondition")

        tap(try addButton())

        XCTAssertTrue(view.input.input.isFirstResponder, "keyboard is shown")
    }
}

class SingleEventEventsListControllerTests:
    XCTestCase,
    EventsListControllerTestsHelpers
{
    var sut: EventsListController!

    override func setUp() {
        super.setUp()
        sut = makeSUT(events: [Event(name: "event")])
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoad_rendersNormalAddButton() throws {
        let button = try addButton()

        XCTAssertFalse(button.isHighlighted)
        XCTAssertEqual(
            button.backgroundColor?.cgColor,
            UIHelper.itemBackground.cgColor
        )
    }

    func test_viewDidLoad_rendersFirstHappeningHint() {
        XCTAssertEqual(hintText(), String(localizationId: "eventsList.hint.firstHappening"))
    }

    func test_viewDidLoad_rendersOneEventCell() {
        XCTAssertNotNil(cell(at: IndexPath(row: 0, section: 1)))
    }

    func test_viewDidLoad_rendersRenameButton() {
        let renameAction = view.table.delegate?.tableView?(
            view.table,
            trailingSwipeActionsConfigurationForRowAt: IndexPath(
                row: 0, section: 1
            )
        )

        XCTAssertEqual(
            renameAction?.actions[1].title,
            String(localizationId: "button.rename")
        )
    }

    func test_viewDidLoad_rendersDeleteButton() {
        let renameAction = view.table.delegate?.tableView?(
            view.table,
            trailingSwipeActionsConfigurationForRowAt: IndexPath(
                row: 0, section: 1
            )
        )

        XCTAssertEqual(
            renameAction?.actions[0].title,
            String(localizationId: "button.delete")
        )
    }
}

protocol EventsListControllerTestsHelpers {
    var sut: EventsListController! { get set }
}

extension EventsListControllerTestsHelpers {
    func makeSUT(events: [Event] = []) -> EventsListController {
        let view = EventsListView()
        let viewModel = EventsListViewModelFake(events: events)
        let sut = EventsListController(viewRoot: view, viewModel: viewModel)
        sut.loadViewIfNeeded()
        return sut
    }

    var view: EventsListView { sut.viewRoot }

    func hintText() -> String {
        let index = IndexPath(row: 0, section: EventsListController.Section.hint.rawValue)

        do {
            let hintCell = try XCTUnwrap(cell(at: index) as? EventsListHintCell)
            return hintCell.label.text ?? ""
        } catch {
            return ""
        }
    }

    func addButton() throws -> UIButton {
        let index = IndexPath(row: 0, section: EventsListController.Section.footer.rawValue)
        let footerCell = try XCTUnwrap(cell(at: index) as? EventsListFooterCell)
        return footerCell.createEvent
    }

    func cell(at indexPath: IndexPath) -> UITableViewCell? {
        let table = view.table
        let dataSource = table.dataSource
        return dataSource?.tableView(table, cellForRowAt: indexPath)
    }
}

class EventsListViewModelFake: EventsListViewModel {
    init(events: [Event] = []) {
        let repository = EventsRepositoryFake(events: events)
        let widgetUC = WidgetUseCaseStub()
        let factoryStub = EventsListFactoryStub()

        let listUC = EventsListUseCase(
            repository: repository,
            widgetUseCase: widgetUC
        )
        let editUC = EventEditUseCase(
            repository: repository,
            widgetUseCase: widgetUC
        )

        super.init(
            listUseCase: listUC,
            editUseCase: editUC,
            factory: factoryStub
        )
    }
}

class EventsRepositoryFake: EventsRepositoryInterface {
    private var events: [Event]

    init(events: [Event]) {
        self.events = events
    }

    func makeAllEvents() -> [Domain.Event] { events }

    func save(_ event: Domain.Event) {
        events.append(event)
    }

    func delete(_ event: Domain.Event) {
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
        }
    }
}

class WidgetUseCaseStub: WidgetsUseCasing {
    func update() {}
}

class EventsListFactoryStub: EventsListFactoryInterface {
    func makeEventCellViewModel(event: Domain.Event) -> Application.EventCellViewModel {
        EventCellViewModel(
            event: event,
            editUseCase: EventEditUseCase(
                repository: EventsRepositoryFake(events: []),
                widgetUseCase: WidgetUseCaseStub()
            )
        )
    }
}
