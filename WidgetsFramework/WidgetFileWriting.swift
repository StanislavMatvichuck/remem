//
//  WidgetFileWriting.swift
//  IosUseCases
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation

public protocol WidgetFileWriting {
    func update(eventsList: [Event], for: WidgetDescription)
}

public class WidgetFileWriter: WidgetFileWriting {
    public init() {}

    public func update(eventsList: [Event], for description: WidgetDescription) {
        guard
            let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.remem.io")
        else { return }

        let fileName = description.rawValue
        let filePath = fileName + ".plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()

        let widgetEventRows: [WidgetRowViewModel] = {
            var result = [WidgetRowViewModel]()
            for event in eventsList {
                let row = WidgetRowViewModel(event: event)
                result.append(row)
            }
            return result
        }()

        let widgetViewModel = WidgetViewModel(viewModel: widgetEventRows)

        do {
            let dataToWrite = try encoder.encode(widgetViewModel)
            try dataToWrite.write(to: fileURL)
        } catch {
            print("unable to write to \(fileURL.absoluteString)")
            print(error.localizedDescription)
            return
        }
    }
}
