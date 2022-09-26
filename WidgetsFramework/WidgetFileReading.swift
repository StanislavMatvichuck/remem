//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

public protocol WidgetFileReading {
    func read() -> WidgetViewModel?
    func readStaticPreview() -> WidgetViewModel
}

public class WidgetFileReader: WidgetFileReading {
    public func readStaticPreview() -> WidgetViewModel {
        let localURL = Bundle(for: Self.self).url(forResource: "WidgetPreview", withExtension: "plist")!
        let fileContent = try! Data(contentsOf: localURL)
        let viewModel = try! PropertyListDecoder().decode(WidgetViewModel.self, from: fileContent)
        return viewModel
    }
    
    public func read() -> WidgetViewModel? {
        guard
            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first
        else { return nil }
        
        let fileURL = documentsDirectory.appendingPathComponent("WidgetData.plist")
        
        guard let fileContent = try? Data(contentsOf: fileURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        
        let viewModel = try? decoder.decode(WidgetViewModel.self, from: fileContent)
        
        return viewModel
    }

    public init() {}
}
