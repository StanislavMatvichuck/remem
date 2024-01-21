//
//  EventsSorterManualRepository.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 21.01.2024.
//

import Domain
import Foundation

public struct EventsSorterManualRepository: EventsSortingManualQuerying, EventsSortingManualCommanding {
    private static let decoder = PropertyListDecoder()
    private static let encoder = PropertyListEncoder()

    private let provider: URLProviding

    public init(_ provider: URLProviding) { self.provider = provider }

    public func get() -> [String] {
        do {
            let data = try Data(contentsOf: provider.url)
            let sorter = try Self.decoder.decode([String].self, from: data)
            return sorter
        } catch { return [] }
    }

    public func set(_ sortingIds: [String]) {
        do {
            let data = try Self.encoder.encode(sortingIds)
            try data.write(to: provider.url)
        } catch {
            fatalError(String(describing: error))
        }
    }
}
