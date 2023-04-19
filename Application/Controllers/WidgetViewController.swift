//
//  WidgetViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Foundation
import WidgetKit

typealias WidgetViewModel = [EventItemViewModel]

final class WidgetViewController {
    func update(_ vm: WidgetViewModel) {
        guard let directory = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return }

        let filePath = "RememWidgets.plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()
        let writableItems = vm.prefix(3).map { WidgetEventItemViewModel(item: $0) }

        do {
            let dataToWrite = try encoder.encode(writableItems)
            try dataToWrite.write(to: fileURL)
            WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
        } catch {
            fatalError("unable to update widget \(fileURL.absoluteString) \(vm) \(writableItems)")
        }
    }
}

extension WidgetEventItemViewModel {
    init(item: EventItemViewModel) {
        name = item.title
        amount = item.value
    }
}
