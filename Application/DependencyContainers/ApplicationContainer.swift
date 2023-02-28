//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

final class ApplicationContainer {
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinator

    init(testingInMemoryMode: Bool = false) {
        print("ApplicationContainer.init")
        let coordinator = Coordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: testingInMemoryMode),
            mapper: EventEntityMapper()
        )

        self.coordinator = coordinator
        self.provider = repository
        self.commander = repository

        scanLaunchArgumentsAndPrepareRepositoryIfNeeded(repository)
    }

    deinit { print("ApplicationContainer.deinit") }

    func makeRootViewController() -> UIViewController {
        coordinator.show(Navigation.eventsList(factory: makeContainer()))
        return coordinator.navigationController
    }

    func makeContainer() -> EventsListContainer { EventsListContainer(parent: self) }
}
