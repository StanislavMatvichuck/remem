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
    typealias Repository = EventsQuerying & EventsCommanding

    let mode: LaunchMode
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinator
    let updater: ViewControllersUpdater
    let watcher: Watching
    let injectedCurrentMoment: Date

    var currentMoment: Date { mode == .injectedCurrentMoment ? injectedCurrentMoment : mode.currentMoment }

    init(mode: LaunchMode, currentMoment: Date = DayIndex.referenceValue.date) {
        func makeRepository(_ mode: LaunchMode) -> EventsQuerying & EventsCommanding {
            let repository = CoreDataEventsRepository(
                container: CoreDataStack.createContainer(inMemory: mode != .uikit),
                mapper: EventEntityMapper()
            )

            let repositoryConfigurator = UITestRepositoryConfigurator()
            repositoryConfigurator.configure(repository: repository, for: mode)

            return repository
        }

        let coordinator = Coordinator()
        let repository = makeRepository(mode)
        let updatingCommander = UpdatingEventsCommander(commander: repository)
        let watcher = DayWatcher()

        self.mode = mode
        self.injectedCurrentMoment = currentMoment
        self.coordinator = coordinator
        self.provider = repository
        self.commander = updatingCommander
        self.updater = ViewControllersUpdater()
        self.watcher = watcher

        let weakUpdater = WeakRef(updater)
        updatingCommander.delegate = weakUpdater
        watcher.delegate = weakUpdater
    }

    static func parseLaunchMode() -> LaunchMode {
        let launchArguments = ProcessInfo.processInfo.arguments

        for argument in launchArguments {
            if let parameter = LaunchMode(rawValue: argument) {
                return parameter
            }
        }

        return .uikit
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(Navigation.eventsList(factory: EventsListContainer(self)))
        return coordinator.navigationController
    }

    func makeWatcher() -> Watching { watcher }
}
