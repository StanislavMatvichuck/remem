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
        forSecurityApplicationGroupIdentifier: "group.remem.io"
    )?.appendingPathComponent("RememWidgets.plist") }

    private let eventsListFactory: EventsListFactoring
    private let eventCellFactory: LoadableEventCellViewModelFactoring

    init(
        eventsListFactory: EventsListFactoring,
        eventCellFactory: LoadableEventCellViewModelFactoring
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

            for id in eventsIdentifiers {
                let loadedEventCellVm = try await eventCellFactory.makeLoadedEventCellViewModel(eventId: id)
                if let vm = loadedEventCellVm.vm {
                    writableItems.append(WidgetEventCellViewModel(item: vm))
                }
            }

            do {
                let dataToWrite = try Self.encoder.encode(writableItems)
                try dataToWrite.write(to: widgetFileURL)
                WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
            } catch {
                fatalError("unable to update widget \(widgetFileURL.absoluteString)")
            }
        }
    }
}

extension WidgetEventCellViewModel {
    init(item: EventCellViewModel) {
        title = item.title
        value = item.value
        timeSince = item.timeSince
        progress = item.goal?.progress
    }
}
