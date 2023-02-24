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
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = container.makeController()
        sut.loadViewIfNeeded()
        commander = container.weekViewModelUpdater
    }

    func sendEventUpdatesToController() {
        commander.save(event)
    }
}
