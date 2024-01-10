//
//  DayDetailsControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.11.2022.
//

@testable import Application
import Domain
import XCTest

extension TestingViewController where Controller == DayDetailsViewController {
    func make() {
        event = Event(name: "Event", dateCreated: DayIndex.referenceValue.date)
        let container = EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)
        sut = DayDetailsContainer(container, startOfDay: DayIndex.referenceValue.date).make() as? DayDetailsViewController
        sut.loadViewIfNeeded()
    }

    var firstIndex: IndexPath { IndexPath(row: 0, section: 0) }
    var happeningsAmount: Int {
        sut.viewRoot.happeningsCollection.dataSource?.collectionView(
            sut.viewRoot.happeningsCollection,
            numberOfItemsInSection: 0
        ) ?? 0
    }

    func happening(at index: IndexPath) -> DayCell {
        do {
            let cell = sut.viewRoot.happeningsCollection.dataSource?.collectionView(
                sut.viewRoot.happeningsCollection,
                cellForItemAt: index
            )
            return try XCTUnwrap(cell as? DayCell)
        } catch { fatalError("happening getting error") }
    }

    func addHappening(at date: Date) {
        event.addHappening(date: date)
    }

    func sendEventUpdatesToController() {
        sut.update()
    }
}
