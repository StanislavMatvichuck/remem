//
//  WidgetViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Foundation
import WidgetKit

final class WidgetViewController {
    func update(_ viewModel: EventsListViewModel) {
        guard let directory = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return }

        let filePath = "RememWidgets.plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()
        guard let eventCells = viewModel.cells(for: .events) as? [EventCellViewModel] else { return }
        let writableItems = eventCells.prefix(3).map { WidgetEventCellViewModel(item: $0) }

        do {
            let dataToWrite = try encoder.encode(writableItems)
            try dataToWrite.write(to: fileURL)
            WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
        } catch {
            fatalError("unable to update widget \(fileURL.absoluteString) \(viewModel) \(writableItems)")
        }
    }
}

extension WidgetEventCellViewModel {
    init(item: EventCellViewModel) {
        title = item.title
        value = item.value
        timeSince = item.timeSince
        progress = item.progress
        goalState = GoalState(rawValue: item.progressState.rawValue)!
    }
}
