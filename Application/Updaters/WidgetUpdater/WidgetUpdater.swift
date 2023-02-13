//
//  WidgetFileWriting.swift
//  IosUseCases
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation
import WidgetKit

protocol DisplayingWidget {
    func update(items: [EventItemViewModel])
}

final class WidgetUpdater {
    var factory: EventsListViewModelFactoring?
    private let provider: EventsQuerying
    private let decorated: EventsCommanding

    init(provider: EventsQuerying, decorated: EventsCommanding) {
        self.provider = provider
        self.decorated = decorated
    }
}

extension WidgetUpdater: EventsCommanding {
    func save(_ event: Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Event) {
        decorated.delete(event)
        update()
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        let newViewModel = factory.makeEventsListViewModel(events: provider.get())
        let items = newViewModel.items.filter { type(of: $0) is EventItemViewModel.Type } as! [EventItemViewModel]
        update(items: items)
    }
}

extension WidgetUpdater: DisplayingWidget {
    func update(items: [EventItemViewModel]) {
        guard let directory = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return }

        let filePath = "RememWidgets.plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()
        let writableItems = items.prefix(3).map { WidgetEventItemViewModel(item: $0) }

        do {
            let dataToWrite = try encoder.encode(writableItems)
            try dataToWrite.write(to: fileURL)
            WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
        } catch {
            fatalError("unable to update widget \(fileURL.absoluteString) \(items) \(writableItems)")
        }
    }
}

extension WidgetEventItemViewModel {
    init(item: EventItemViewModel) {
        name = item.name
        amount = item.amount
    }
}
