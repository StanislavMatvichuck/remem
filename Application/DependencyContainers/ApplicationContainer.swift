//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

final class ApplicationContainer: EventsListContainerFactoring {
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: DefaultCoordinator

    init(testingInMemoryMode: Bool = false) {
        let coordinator = DefaultCoordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: testingInMemoryMode),
            mapper: EventEntityMapper()
        )

        self.coordinator = coordinator
        self.provider = repository
        self.commander = repository

        scanLaunchArgumentsAndPrepareRepositoryIfNeeded(repository)

        coordinator.listFactory = self
    }

    func makeRootViewController() -> UIViewController {
        coordinator.state = .eventsList
        return coordinator.navController
    }

    func makeContainer() -> EventsListContainer {
        EventsListContainer(
            provider: provider,
            commander: commander,
            coordinator: coordinator
        )
    }
}
