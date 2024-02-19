//
//  EventsListControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == EventsListViewController {
    var list: UICollectionView { sut.viewRoot.list }
    var eventsCount: Int {
        sut.viewModel?.cellsIdentifiers(for: .events).count ?? 0
    }

    func make() {
        sut = EventsListContainer(ApplicationContainer(mode: .unitTest)).make() as? EventsListViewController
        sut.loadViewIfNeeded()
    }

    func arrangeSingleEventSwiped() {
        submitEvent()
        swipeFirstEvent()
    }

    func swipeFirstEvent() {
        if let cellId = sut.viewModel?.cellsIdentifiers(for: .events).first,
           let cell = sut.viewModel?.cell(identifier: cellId) as? EventCellViewModel
        { cell.swipeHandler() }
    }

    func submitEvent() {}

    var hintText: String? {
        if let cellId = sut.viewModel?.cellsIdentifiers(for: .hint).first,
           let cell = sut.viewModel?.cell(identifier: cellId) as? HintCellViewModel
        { cell.title } else { nil }
    }

    var firstEvent: EventCell {
        let presentSections = sut.viewModel!.sections
        for (index, presentSection) in presentSections.enumerated() {
            if presentSection == .events {
                return list.cellForItem(
                    at: IndexPath(row: 0, section: index)
                ) as! EventCell
            }
        }
        fatalError()
    }

    func forceViewToLayoutInScreenSize() {
        sut.view.bounds = UIScreen.main.bounds
        sut.view.layoutIfNeeded()
    }

    // MARK: - Specific cases
    func makeWithVisitedEvent() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.visit()
        let appC = ApplicationContainer(mode: .uikit)
        appC.commander.save(event)
        let container = EventsListContainer(appC)
        sut = container.make() as? EventsListViewController
    }

    func makeWithManyEvents() {
        submitEvent()
        swipeFirstEvent()
        submitEvent()
        submitEvent()
    }
}
