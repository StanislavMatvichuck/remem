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

    var currentMoment: Date {
        currentMomentInjected ? UITestRepositoryConfigurator.viewAndExportToday.date : .now
    }

    private var currentMomentInjected: Bool { return
        mode == .appPreview02_viewDetailsAndExport ||
        mode == .appPreview02_addWeeklyGoal ||
        mode == .appPreview03_widget
    }

    init(mode: LaunchMode) {
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
        let updatingCommander = UpdatingCommander(commander: repository)
        let watcher = DayWatcher()

        self.mode = mode
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
        coordinator.show(Navigation.eventsList(factory: makeContainer()))
        return coordinator.navigationController
    }

    func makeWatcher() -> Watching { watcher }

    func makeContainer() -> EventsListContainer { EventsListContainer(parent: self) }
}
