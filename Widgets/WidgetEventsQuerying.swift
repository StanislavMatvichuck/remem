//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

class WidgetEventsQuerying {
    func getPreview() -> [WidgetEventItemViewModel] {
        let localURL = Bundle(for: Self.self).url(
            forResource: "WidgetPreview",
            withExtension: "plist"
        )!
        let fileContent = try! Data(contentsOf: localURL)
        let viewModel = try! PropertyListDecoder().decode([WidgetEventItemViewModel].self, from: fileContent)
        return viewModel
    }

    func getFromFile() -> [WidgetEventItemViewModel] {
        guard let directoryURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return [] }

        let filePath = "RememWidgets.plist"
        let fileURL = directoryURL.appendingPathComponent(filePath)

        guard let fileContent = try? Data(contentsOf: fileURL) else { return [] }

        let decoder = PropertyListDecoder()

        guard let viewModel = try? decoder.decode([WidgetEventItemViewModel].self, from: fileContent)
        else { return [] }

        return viewModel
    }
}
