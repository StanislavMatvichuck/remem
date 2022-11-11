//
//  Fakes.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import Domain
import IosUseCases

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
