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

class EventsListControllerTests: XCTestCase {
    // MARK: - Test fixture
    var sut: EventsListController!

    var view: EventsListView { sut.viewRoot }
    var table: UITableView { view.table }
    var firstCellIndex: IndexPath {
        IndexPath(
            row: 0,
            section: EventsListController.Section.events.rawValue
        )
    }

    override func setUp() {
        super.setUp()
        sut = EventsListController.make()
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_empty_hasTitle() {
        XCTAssertEqual(sut.title, String(localizationId: "eventsList.title"))
    }

    func test_empty_tableIsConfigured() throws {
        XCTAssertNotNil(table.dataSource)
        XCTAssertNotNil(table.delegate)
    }

    func test_empty_tableHasThreeSections() throws {
        XCTAssertEqual(
            table.numberOfSections,
            EventsListController.Section.allCases.count
        )

        XCTAssertEqual(table.numberOfRows(inSection: EventsListController.Section.hint.rawValue), 1)
        XCTAssertEqual(table.numberOfRows(inSection: EventsListController.Section.events.rawValue), 0)
        XCTAssertEqual(table.numberOfRows(inSection: EventsListController.Section.footer.rawValue), 1)
    }

    func test_empty_rendersEmptyHint() {
        XCTAssertEqual(
            sut.hintText(),
            String(localizationId: "eventsList.hint.empty")
        )
    }

    func test_empty_gestureHintIsNotVisible() {
        let gestureHint = view.swipeHint

        XCTAssertNil(gestureHint.superview)
    }

    func test_empty_rendersHighlightedAddButton() throws {
        let button = sut.addButton()

        let title = NSAttributedString(
            string: String(localizationId: "button.create"),
            attributes: [
                NSAttributedString.Key.font: UIHelper.fontSmallBold,
            ]
        )

        XCTAssertEqual(button.attributedTitle(for: .normal), title, "Button text and styling")
        XCTAssertTrue(button.isHighlighted, "Button must be highlighted when list is empty")
    }

    func test_singleEvent_rendersNormalAddButton() throws {
        submitEvent()

        let button = sut.addButton()

        XCTAssertFalse(button.isHighlighted)
        XCTAssertEqual(
            button.backgroundColor?.cgColor,
            UIHelper.itemBackground.cgColor
        )
    }

    func test_singleEvent_rendersFirstHappeningHint() {
        submitEvent()

        XCTAssertEqual(sut.hintText(), String(localizationId: "eventsList.hint.firstHappening"))
    }

    func test_singleEvent_rendersOneEventCell() throws {
        submitEvent()

        _ = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)
    }

    func test_singleEvent_rendersGestureHint() throws {
        submitEvent()

        /// this required to trigger data source methods that mutate the view
        /// needs fix?
        _ = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)

        XCTAssertNotNil(sut.viewRoot.swipeHint.superview)
    }

    func test_singleEvent_rendersRenameButton() {
        submitEvent()

        let renameAction = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: firstCellIndex
        )

        XCTAssertEqual(
            renameAction?.actions[1].title,
            String(localizationId: "button.rename")
        )
    }

    func test_singleEvent_rendersDeleteButton() {
        submitEvent()

        let renameAction = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: firstCellIndex
        )

        XCTAssertEqual(
            renameAction?.actions[0].title,
            String(localizationId: "button.delete")
        )
    }

    func test_singleEvent_swipe_increasesLabelAmountByOne() throws {
        arrangeSingleEventSwiped()

        let cellAfterSwipe = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)
        XCTAssertEqual(cellAfterSwipe.valueLabel.text, "1")
    }

    func test_singleEvent_swipe_swipe_increasesLabelAmountByTwo() throws {
        let eventCell = arrangeSingleEventSwiped()

        eventCell.swiper.sendActions(for: .primaryActionTriggered)

        let cellAfterSwipe = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)
        XCTAssertEqual(cellAfterSwipe.valueLabel.text, "2")
    }

    func test_singleEvent_swipe_rendersPressToSeeDetailsHint() {
        arrangeSingleEventSwiped()

        XCTAssertEqual(sut.hintText(), String(localizationId: "eventsList.hint.firstVisit"))
    }

    func test_singleEvent_swipe_gestureHintIsNotVisible() {
        arrangeSingleEventSwiped()

        XCTAssertNil(sut.viewRoot.swipeHint.superview)
    }

    func test_addButtonTapped_keyboardShown() throws {
        putInViewHierarchy(sut)

        XCTAssertFalse(view.input.textField.isFirstResponder, "precondition")

        tap(sut.addButton())

        XCTAssertTrue(view.input.textField.isFirstResponder, "keyboard is shown")
    }

    func test_empty_submittingEvent_addsEventToList() {
        submitEvent()

        XCTAssertEqual(table.numberOfRows(inSection: firstCellIndex.section), 1)

        if let cell = sut.cell(at: firstCellIndex) as? EventCell {
            XCTAssertEqual(cell.nameLabel.text, "SubmittedEventName")
        } else {
            XCTFail("submitted name must appear in list")
        }
    }

    @discardableResult
    private func arrangeSingleEventSwiped() -> EventCell {
        do {
            submitEvent()
            let cell = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)
            XCTAssertEqual(cell.valueLabel.text, "0", "precondition")
            cell.swiper.sendActions(for: .primaryActionTriggered)
            return cell
        } catch { fatalError("failed to arrange single event in a list") }
    }

    private func submitEvent() {
        view.input.value = "SubmittedEventName"

        XCTAssertEqual(
            table.numberOfRows(inSection: firstCellIndex.section), 0,
            "precondition"
        )

        _ = view.input.textField.delegate?.textFieldShouldReturn?(view.input.textField)
    }
}

private extension EventsListController {
    static func make(events: [Event] = []) -> EventsListController {
        let listUCfake = EventsListUseCasingFake(events: events)
        let editUCfake = EventEditUseCasingFake()

        let sut = EventsListController(
            viewRoot: EventsListView(),
            listUseCase: listUCfake,
            editUseCase: editUCfake
        )
        sut.loadViewIfNeeded()
        return sut
    }

    func hintText() -> String {
        let index = IndexPath(row: 0, section: EventsListController.Section.hint.rawValue)

        do {
            let hintCell = try XCTUnwrap(cell(at: index) as? EventsListHintCell)
            return hintCell.label.text ?? ""
        } catch {
            return ""
        }
    }

    func addButton() -> UIButton {
        let index = IndexPath(row: 0, section: EventsListController.Section.footer.rawValue)
        do {
            let footerCell = try XCTUnwrap(cell(at: index) as? EventsListFooterCell)
            return footerCell.createEvent
        } catch {
            XCTFail(error.localizedDescription)
            return UIButton()
        }
    }

    func cell(at indexPath: IndexPath) -> UITableViewCell? {
        let table = viewRoot.table
        let dataSource = table.dataSource
        return dataSource?.tableView(table, cellForRowAt: indexPath)
    }
}
