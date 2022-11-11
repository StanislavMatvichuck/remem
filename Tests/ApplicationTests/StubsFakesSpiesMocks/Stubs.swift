//
//  Stubs.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import Domain
import IosUseCases

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
