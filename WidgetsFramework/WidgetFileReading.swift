//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

public protocol WidgetFileReading {
    func read(url: URL) throws -> WidgetViewModel
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

    public init() {}
}
