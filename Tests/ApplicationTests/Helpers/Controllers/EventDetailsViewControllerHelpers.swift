//
//  EventDetailsViewControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

@testable import Application
import Domain

protocol EventDetailsViewControllerTesting: AnyObject {
    var event: Event! { get set }
    var sut: EventDetailsViewController! { get set }
    var viewModelFactory: EventViewModelFactoring! { get set }
}

extension EventDetailsViewControllerTesting {
    func makeSutWithViewModelFactory() {
        let today = DayComponents.referenceValue
        event = Event(name: "Event", dateCreated: today.date)
        let container = ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
        sut = container.makeController()
        viewModelFactory = container
    }

    func clearSutAndViewModelFactory() {
        event = nil
        sut = nil
        viewModelFactory = nil
    }
}
