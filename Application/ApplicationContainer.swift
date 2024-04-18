//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import CoreData
import DataLayer
import Domain
import UIKit

final class ApplicationContainer {
    typealias Repository = EventsQuerying & EventsCommanding

    let mode: LaunchMode
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinator
    let watcher: Watching
    let coreDataContainer: NSPersistentContainer
    let injectedCurrentMoment: Date

    var currentMoment: Date { mode == .injectedCurrentMoment ? injectedCurrentMoment : mode.currentMoment }

    init(mode: LaunchMode, currentMoment: Date = DayIndex.referenceValue.date) {
        func makeRepository(_ mode: LaunchMode, coreDataContainer: NSPersistentContainer) -> EventsQuerying & EventsCommanding {
            let repository = CoreDataEventsRepository(
                container: coreDataContainer,
                mapper: EventEntityMapper()
            )

            let repositoryConfigurator = UITestRepositoryConfigurator()
            repositoryConfigurator.configure(repository: repository, for: mode)

            return repository
        }

        let container = CoreDataStack.createContainer(inMemory: mode != .uikit)
        let repository = makeRepository(mode, coreDataContainer: container)
        let watcher = DayWatcher()
        let coordinator = Coordinator()

        self.mode = mode
        self.injectedCurrentMoment = currentMoment
        self.coordinator = coordinator
        self.provider = repository
        self.commander = repository
        self.coreDataContainer = container
        self.watcher = watcher
//        watcher.delegate = weakUpdater
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

    func makeRootViewController() -> UIViewController { coordinator.navigationController }
    func makeWatcher() -> Watching { watcher }
    func makeShowEventsListService() -> ShowEventsListService { ShowEventsListService(
        coordinator: coordinator,
        factory: EventsListContainer(self),
        eventsProvider: provider
    ) }
}
