//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

public protocol WidgetFileReading {
    func read(url: URL) throws -> WidgetViewModel
    func readStaticPreview() -> WidgetViewModel
}

public class WidgetFileReader: WidgetFileReading {
    public func read(url: URL) throws -> WidgetViewModel {
        WidgetViewModel(date: .now, viewModel: [])
//        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.rderik.sharefriends")
//                guard let archiveURL = documentsDirectory?.appendingPathComponent("rderikFriends.json") else { return [Friends]() }
//
//                guard let codeData = try? Data(contentsOf: archiveURL) else { return [] }
//
//                let decoder = JSONDecoder()
//
//                let loadedFriends = (try? decoder.decode([Friend].self, from: codeData)) ?? [Friend]()
//
//                return loadedFriends
    }
    
    public func readStaticPreview() -> WidgetViewModel {
        let localURL = Bundle(for: Self.self).url(forResource: "WidgetPreview", withExtension: "plist")!
        let fileContent = try! Data(contentsOf: localURL)
        let viewModel = try! PropertyListDecoder().decode(WidgetViewModel.self, from: fileContent)
        return viewModel
    }

    public init() {}
}
