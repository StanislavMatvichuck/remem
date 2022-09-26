//
//  WidgetFileWriting.swift
//  IosUseCases
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation

public protocol WidgetFileWriting {
    func update(eventsList: [Event])
}

public class WidgetFileWriter: WidgetFileWriting {
    public init() {}

    public func update(eventsList: [Event]) {
        guard
            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first
        else { return }

        let fileURL = documentsDirectory.appendingPathComponent("WidgetData.plist")
        let encoder = PropertyListEncoder()

        let widgetEventRows: [WidgetRowViewModel] = {
            var result = [WidgetRowViewModel]()
            for event in eventsList {
                // TODO: make nice init for this
                let row = WidgetRowViewModel(name: event.name,
                                             amount: String(event.happenings.count),
                                             hasGoal: false,
                                             goalReached: false)
                result.append(row)
            }
            return result
        }()

        let widgetViewModel = WidgetViewModel(date: .now, viewModel: widgetEventRows)

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
