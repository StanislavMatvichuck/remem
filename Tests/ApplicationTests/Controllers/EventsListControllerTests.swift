//
//  EventsListTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 12.10.2022.
//

@testable import Application
import Domain
import IosUseCases
import ViewControllerPresentationSpy
import XCTest

class EventsListControllerTests: XCTestCase {
    // MARK: - Test fixture
    var sut: EventsListController!
    var coordinator: Coordinating!

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

        let coordinator = ApplicationFactory().makeCoordinator()
        self.coordinator = coordinator

        let sut = EventsListController.make(coordinator: coordinator)
        self.sut = sut

        coordinator.navController.pushViewController(sut, animated: false)
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        coordinator = nil
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

    func test_empty_addButtonTapped_keyboardShown() throws {
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
        let renameButton = arrangeFirstEventSwipeAction(number: 1)

        XCTAssertEqual(
            renameButton.title,
            String(localizationId: "button.rename")
        )
    }

    func test_singleEvent_renamePressed_showsKeyboardWithEventName() {
        putInViewHierarchy(sut)
        let renameButton = arrangeFirstEventSwipeAction(number: 1)
        XCTAssertFalse(view.input.textField.isFirstResponder)

        renameButton.handler(renameButton, UIView()) { _ in }

        XCTAssertTrue(view.input.textField.isFirstResponder)
        XCTAssertEqual(view.input.value, "SubmittedEventName")
    }

    func test_singleEvent_submittingRename_changesEventName() throws {
        putInViewHierarchy(sut)
        let renameButton = arrangeFirstEventSwipeAction(number: 1)
        renameButton.handler(renameButton, UIView()) { _ in }
        view.input.value = "ChangedName"

        view.input.textField.delegate?.textFieldShouldReturn?(view.input.textField)

        let eventCell = try XCTUnwrap(sut.cell(at: firstCellIndex) as? EventCell)
        XCTAssertEqual(eventCell.nameLabel.text, "ChangedName")
    }

    func test_singleEvent_rendersDeleteButton() {
        let deleteButton = arrangeFirstEventSwipeAction(number: 0)

        XCTAssertEqual(
            deleteButton.title,
            String(localizationId: "button.delete")
        )
    }

    func test_singleEvent_deletePressed_removesEventFromList() throws {
        let deleteButton = arrangeFirstEventSwipeAction(number: 0)

        XCTAssertEqual(table.numberOfRows(inSection: firstCellIndex.section), 1, "precondition")

        deleteButton.handler(deleteButton, UIView()) { _ in }

        XCTAssertEqual(table.numberOfRows(inSection: firstCellIndex.section), 0, "precondition")
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

    func test_singleEvent_eventTapped_opensEventDetails() throws {
        let navigationController = sut.navigationController

        XCTAssertEqual(navigationController?.viewControllers.count, 1, "precondition")

        submitEvent()

        table.delegate?.tableView?(table, didSelectRowAt: firstCellIndex)

        executeRunLoop()

        XCTAssertEqual(navigationController?.viewControllers.count, 2)
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

    private func arrangeFirstEventSwipeAction(number: Int) -> UIContextualAction {
        submitEvent()

        let configuration = table.delegate?.tableView?(
            table,
            trailingSwipeActionsConfigurationForRowAt: firstCellIndex
        )

        return configuration!.actions[number]
    }
}

private extension EventsListController {
    static func make(events: [Event] = [], coordinator: Coordinating) -> EventsListController {
        let listUCfake = EventsListUseCasingFake(events: events)
        let editUCfake = EventEditUseCasingFake()

        let sut = EventsListController(
            listUseCase: listUCfake,
            editUseCase: editUCfake,
            coordinator: coordinator
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
