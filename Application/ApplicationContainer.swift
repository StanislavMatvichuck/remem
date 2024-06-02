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
    typealias Repository = EventsReading & EventsWriting

    let mode: LaunchMode
    let provider: EventsReading
    let eventsStorage: EventsWriting
    let coordinator: Coordinator
    let coreDataContainer: NSPersistentContainer
    let injectedCurrentMoment: Date

    var currentMoment: Date { mode == .injectedCurrentMoment ? injectedCurrentMoment : mode.currentMoment }

    init(mode: LaunchMode, currentMoment: Date = DayIndex.referenceValue.date) {
        func makeRepository(_ mode: LaunchMode, coreDataContainer: NSPersistentContainer) -> EventsReading & EventsWriting {
            let repository = CoreDataEventsRepository(container: coreDataContainer)

            let repositoryConfigurator = UITestRepositoryConfigurator()
            repositoryConfigurator.configure(repository: repository, for: mode)

            return repository
        }

        let coreDataOperatesWithStoredData =
            mode == .uikit ||
            mode == .performanceTest ||
            mode == .performanceTestWritesData
        let container = CoreDataStack.createContainer(inMemory: !coreDataOperatesWithStoredData)
        let repository = makeRepository(mode, coreDataContainer: container)
        let coordinator = Coordinator()

        self.mode = mode
        self.injectedCurrentMoment = currentMoment
        self.coordinator = coordinator
        self.provider = repository
        self.eventsStorage = repository
        self.coreDataContainer = container
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
    func makeDayWatcher() -> Watching { DayWatcher() }

    func makeShowEventsListService() -> ShowEventsListService { ShowEventsListService(
        coordinator: coordinator,
        factory: EventsListContainer(self),
        eventsProvider: provider
    ) }
}
