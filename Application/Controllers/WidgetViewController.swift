//
//  WidgetViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Foundation
import WidgetKit

typealias WidgetViewModel = [EventItemViewModel]

protocol WidgetViewModelFactoring { func makeWidgetViewModel() -> WidgetViewModel }

final class WidgetViewController: Updating {
    let factory: WidgetViewModelFactoring
    init(_ factory: WidgetViewModelFactoring) { self.factory = factory }

    func update() {
        let viewModel = factory.makeWidgetViewModel()

        guard let directory = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return }

        let filePath = "RememWidgets.plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()
        let writableItems = viewModel.prefix(3).map { WidgetEventItemViewModel(item: $0) }

        do {
            let dataToWrite = try encoder.encode(writableItems)
            try dataToWrite.write(to: fileURL)
            WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
        } catch {
            fatalError("unable to update widget \(fileURL.absoluteString) \(viewModel) \(writableItems)")
        }
    }
}

extension WidgetEventItemViewModel {
    init(item: EventItemViewModel) {
        name = item.name
        amount = item.amount
    }
}
