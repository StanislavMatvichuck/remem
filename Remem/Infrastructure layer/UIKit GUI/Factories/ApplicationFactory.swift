//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import Foundation

class ApplicationFactory {
    // MARK: - Long-lived dependencies
    let eventsListUseCase: EventsListUseCase
    let eventEditUseCase: EventEditUseCase
    let eventEditMulticastDelegate = MulticastDelegate<EventEditUseCaseOutput>()
    let eventsListMulticastDelegate = MulticastDelegate<EventsListUseCaseOutput>()

    // MARK: - Init
    init() {
        func makeEventsRepository() -> EventsRepositoryInterface {
            let container = CoreDataStack.createContainer(inMemory: false)
            let mapper = EventEntityMapper()
            return CoreDataEventsRepository(container: container, mapper: mapper)
        }

        let repository = makeEventsRepository()

        let listUseCase = EventsListUseCase(repository: repository)
        let editUseCase = EventEditUseCase(repository: repository)

        self.eventsListUseCase = listUseCase
        self.eventEditUseCase = editUseCase
    }

    func makeCoordinator() -> Coordinator {
        let coordinatorContainer = CoordinatorFactory(applicationFactory: self)
        let coordinator = coordinatorContainer.makeCoordinator()
        return coordinator
    }
}
