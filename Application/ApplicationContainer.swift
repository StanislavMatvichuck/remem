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
    let mode: LaunchMode
    let eventsReader: EventsReading
    let eventsWriter: EventsWriting
    let goalsReader: GoalsReading
    let goalsWriter: GoalsWriting
    let coordinator: Coordinator
    let coreDataContainer: NSPersistentContainer
    let injectedCurrentMoment: Date
    let viewModelsLoadingHandler: LoadableViewModelHandling = LoadableViewModelHandler()

    var currentMoment: Date { mode == .injectedCurrentMoment ? injectedCurrentMoment : mode.currentMoment }

    init(mode: LaunchMode, currentMoment: Date = DayIndex.referenceValue.date) {
        func makeEventsRepository(_ mode: LaunchMode, coreDataContainer: NSPersistentContainer) -> EventsReading & EventsWriting {
            let repository = CoreDataEventsRepository(container: coreDataContainer)

            let repositoryConfigurator = UITestRepositoryConfigurator()
            repositoryConfigurator.configure(reader: repository, writer: repository, for: mode)

            return repository
        }

        func makeGoalsRepository(coreDataContainer: NSPersistentContainer) -> GoalsReading & GoalsWriting {
            GoalsCoreDataRepository(container: coreDataContainer)
        }

        let coreDataOperatesWithStoredData =
            mode == .uikit ||
            mode == .performanceTest ||
            mode == .performanceTestWritesData
        let container = CoreDataStack.createContainer(inMemory: !coreDataOperatesWithStoredData)
        let eventsRepository = makeEventsRepository(mode, coreDataContainer: container)
        let goalsRepository = makeGoalsRepository(coreDataContainer: container)
        let coordinator = Coordinator()

        self.mode = mode
        self.injectedCurrentMoment = currentMoment
        self.coordinator = coordinator
        self.eventsReader = eventsRepository
        self.eventsWriter = eventsRepository
        self.coreDataContainer = container
        self.goalsReader = goalsRepository
        self.goalsWriter = goalsRepository
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
        eventsProvider: eventsReader
    ) }
}
