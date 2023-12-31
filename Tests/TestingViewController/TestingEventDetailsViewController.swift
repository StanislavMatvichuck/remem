//
//  EventDetailsViewControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

@testable import Application
import Domain

extension TestingViewController where Controller == EventDetailsViewController {
    func make() {
        let today = DayIndex.referenceValue
        event = Event(name: "Event", dateCreated: today.date)

        sut = EventDetailsContainer(
            EventsListContainer(
                ApplicationContainer(mode: .unitTest)
            ), event: event
        ).make() as? EventDetailsViewController

        sut.loadViewIfNeeded()
    }

    func sendEventUpdatesToController() {
        sut.update()
    }
}
