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
    enum LaunchMode: String {
        case empty, singleEvent, viewAndExport, unitTest, uikit
    }

    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinator
    let updater: ViewControllersUpdater
    let watcher: Watching
    var currentMoment: Date {
        if mode == .viewAndExport {
            return DayIndex.referenceValue.adding(days: 7).date
        }
        return .now
    }

    let mode: LaunchMode

    init(mode: LaunchMode) {
        self.mode = mode

        let coordinator = Coordinator()
        let repository = Self.makeRepository(mode)

        self.coordinator = coordinator
        self.provider = repository
        let updatingCommander = UpdatingCommander(commander: repository)
        self.commander = updatingCommander

        self.updater = ViewControllersUpdater()
        let watcher = DayWatcher()
        self.watcher = watcher

        let weakUpdater = WeakRef(updater)
        updatingCommander.delegate = weakUpdater
        watcher.delegate = weakUpdater
    }

    private static func makeRepository(_ mode: LaunchMode) -> EventsQuerying & EventsCommanding {
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: mode != .uikit),
            mapper: EventEntityMapper()
        )

        configure(repository: repository, for: mode)

        return repository
    }

    private static func configure(repository: Repository, for mode: LaunchMode) {
        let dateCreated = DayIndex.referenceValue.date
        switch mode {
        case .singleEvent:
            let event = Event(name: "Single event", dateCreated: dateCreated)
            repository.save(event)
        case .viewAndExport:
            let firstEvent = Event(name: "Any event you want to count", dateCreated: dateCreated)
            let secondEvent = Event(name: "Coffee ☕️", dateCreated: dateCreated)
            let thirdEvent = Event(name: "Fitness 👟", dateCreated: dateCreated)
            repository.save(firstEvent)
            repository.save(secondEvent)
            repository.save(thirdEvent)
        default: break
        }
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
