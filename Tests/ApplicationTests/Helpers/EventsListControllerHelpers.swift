//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import XCTest

extension EventsListController {
    static func make(coordinator: Coordinating?) -> EventsListController {
        let coordinator = coordinator ?? ApplicationFactory().makeCoordinator()
        let listUCfake = EventsListUseCasingFake()
        let editUCfake = EventEditUseCasingFake()

        let sut = EventsListController(
            listUseCase: listUCfake,
            editUseCase: editUCfake,
            coordinator: coordinator
        )

        sut.loadViewIfNeeded()

        return sut
    }

    var hint: EventsListHintCell {
        let hintSection = EventsListController.Section.hint.rawValue
        let hintIndexPath = IndexPath(row: 0, section: hintSection)
        let cell = cell(atIndexPath: hintIndexPath)

        do {
            return try XCTUnwrap(cell as? EventsListHintCell)
        } catch { fatalError("unable to get hint") }
    }

    var footer: EventsListFooterCell {
        let footerSection = EventsListController.Section.footer.rawValue
        let footerIndexPath = IndexPath(row: 0, section: footerSection)
        let cell = cell(atIndexPath: footerIndexPath)

        do {
            return try XCTUnwrap(cell as? EventsListFooterCell)
        } catch { fatalError("unable to get footer") }
    }

    var addButton: UIButton { footer.button }
    var firstEvent: EventCell { event(at: 0) }
    var hintText: String? { hint.label.text }
    var eventsCount: Int {
        viewRoot.table.numberOfRows(
            inSection: EventsListController.Section.events.rawValue
        )
    }

    func event(at index: Int) -> EventCell {
        do {
            let indexPath = IndexPath(
                row: index,
                section: EventsListController.Section.events.rawValue
            )
            let cell = cell(atIndexPath: indexPath)
            return try XCTUnwrap(cell as? EventCell)
        } catch { fatalError("unable to get EventCell at \(index)") }
    }

    @discardableResult
    func arrangeSingleEventSwiped() -> EventCell {
        submitEvent()

        /// this part works badly
//        XCTAssertEqual(firstEvent.valueLabel.text, "0", "precondition")
//        firstEvent.swiper.sendActions(for: .primaryActionTriggered)
//        return firstEvent

        /// this works
        let cell = firstEvent
        XCTAssertEqual(cell.valueLabel.text, "0", "precondition")
        cell.swiper.sendActions(for: .primaryActionTriggered)
        return cell
    }

    func submitEvent() {
        viewRoot.input.value = "SubmittedEventName"

        _ = viewRoot.input.textField.delegate?.textFieldShouldReturn?(
            viewRoot.input.textField
        )
    }

    private func cell(atIndexPath: IndexPath) -> UITableViewCell {
        let table = viewRoot.table
        let dataSource = table.dataSource
        if let cell = dataSource?.tableView(table, cellForRowAt: atIndexPath) {
            return cell
        } else { fatalError("unable to get cell at \(atIndexPath)") }
    }
}
