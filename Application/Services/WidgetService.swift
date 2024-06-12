//
//  WidgetUpdateService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.04.2024.
//

import Domain
import Foundation
import WidgetKit

protocol EventsListFactoring { func makeEventsList() -> EventsList }

struct WidgetService: ApplicationService {
    private static let encoder = PropertyListEncoder()
    private var widgetFileURL: URL? { FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: SecurityApplicationGroupId
    )?.appendingPathComponent(WidgetStorageFile) }

    private let eventsListFactory: EventsListFactoring
    private let eventCellFactory: EventCellViewModelFactoryFactoring

    init(
        eventsListFactory: EventsListFactoring,
        eventCellFactory: @escaping EventCellViewModelFactoryFactoring
    ) {
        self.eventsListFactory = eventsListFactory
        self.eventCellFactory = eventCellFactory
    }

    func serve(_ arg: ApplicationServiceEmptyArgument) {
        guard let widgetFileURL else { return }

        Task(priority: .background) {
            let eventsList = eventsListFactory.makeEventsList()
            let eventsIdentifiers = eventsList.eventsIdentifiers.prefix(3)
            var writableItems = [WidgetEventCellViewModel]()

            for identifier in eventsIdentifiers {
                let eventCellFactory = self.eventCellFactory(identifier)
                let loadedEventCellVm = try await eventCellFactory.makeLoaded()
                if let vm = loadedEventCellVm.vm,
                   let widgetVm = WidgetEventCellViewModel(item: vm)
                {
                    writableItems.append(widgetVm)
                }
            }

            do {
                let dataToWrite = try Self.encoder.encode(writableItems)
                try dataToWrite.write(to: widgetFileURL)
                WidgetCenter.shared.reloadTimelines(ofKind: WidgetTimelineKind)
            } catch {
                fatalError("unable to update widget \(widgetFileURL.absoluteString)")
            }
        }
    }
}

extension WidgetEventCellViewModel {
    init?(item: EventCellViewModel) {
        guard let id = UUID(uuidString: item.eventId) else { return nil }
        self.id = id
        title = item.title
        value = item.value
        timeSince = item.timeSince
        progress = item.goal?.progress
    }
}
