//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation
import os

/// Logs can be accessed with Console application
let logger = Logger(subsystem: "io.remem", category: "widget")

class WidgetEventsQuerying {
    func getPreview() -> [WidgetEventCellViewModel] {
        guard let localURL = Bundle(for: Self.self).url(
            forResource: "WidgetPreview",
            withExtension: "plist"
        ) else {
            logger.error("WidgetEventsQuerying.getPreview localURL error")
            return []
        }

        guard let fileContent = try? Data(contentsOf: localURL) else {
            logger.error("WidgetEventsQuerying.getPreview fileContent error")
            return []
        }

        guard let viewModel = try? PropertyListDecoder().decode([WidgetEventCellViewModel].self, from: fileContent) else {
            logger.error("WidgetEventsQuerying.getPreview decoding error")
            return []
        }

        return viewModel
    }

    func getFromFile() -> [WidgetEventCellViewModel] {
        guard let directoryURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return [] }

        let filePath = "RememWidgets.plist"
        let fileURL = directoryURL.appendingPathComponent(filePath)

        guard let fileContent = try? Data(contentsOf: fileURL) else { return [] }

        let decoder = PropertyListDecoder()

        guard let viewModel = try? decoder.decode([WidgetEventCellViewModel].self, from: fileContent)
        else { return [] }

        return viewModel
    }
}
