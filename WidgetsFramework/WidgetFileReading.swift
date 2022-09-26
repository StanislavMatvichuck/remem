//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

public protocol WidgetFileReading {
    func read(for: WidgetDescription) -> WidgetViewModel?
    func readStaticPreview() -> WidgetViewModel
}

public class WidgetFileReader: WidgetFileReading {
    public init() {}
    
    public func readStaticPreview() -> WidgetViewModel {
        let localURL = Bundle(for: Self.self).url(forResource: "WidgetPreview", withExtension: "plist")!
        let fileContent = try! Data(contentsOf: localURL)
        let viewModel = try! PropertyListDecoder().decode(WidgetViewModel.self, from: fileContent)
        return viewModel
    }
    
    public func read(for description: WidgetDescription) -> WidgetViewModel? {
        guard
            let directoryURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.remem.io")
        else { return nil }
        
        let fileName = description.rawValue
        let filePath = fileName + ".plist"
        let fileURL = directoryURL.appendingPathComponent(filePath)
        
        guard let fileContent = try? Data(contentsOf: fileURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        
        let viewModel = try? decoder.decode(WidgetViewModel.self, from: fileContent)
        
        return viewModel
    }
}
