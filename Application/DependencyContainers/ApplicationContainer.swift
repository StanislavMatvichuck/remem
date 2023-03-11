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
    let updater: ViewControllersUpdater
    let watcher: Watching

    init(testingInMemoryMode: Bool = false) {
        let coordinator = Coordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: testingInMemoryMode),
            mapper: EventEntityMapper()
        )

        self.coordinator = coordinator
        self.provider = repository
        let updatingCommander = UpdatingCommander(commander: repository)
        self.commander = updatingCommander

        scanLaunchArgumentsAndPrepareRepositoryIfNeeded(repository)

        self.updater = ViewControllersUpdater()
        let watcher = DayWatcher()
        self.watcher = watcher

        let weakUpdater = WeakRef(updater)
        updatingCommander.delegate = weakUpdater
        watcher.delegate = weakUpdater
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(Navigation.eventsList(factory: makeContainer()))
        return coordinator.navigationController
    }

    func makeWatcher() -> Watching { watcher }

    func makeContainer() -> EventsListContainer { EventsListContainer(parent: self) }
}
