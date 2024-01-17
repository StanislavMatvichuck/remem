//
//  EventsSorterRepository.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import Domain
import Foundation

public struct EventsSorterRepository: EventsSorterQuerying, EventsSorterCommanding {
    private static let decoder = PropertyListDecoder()
    private static let encoder = PropertyListEncoder()

    private let provider: URLProviding

    public init(_ provider: URLProviding) { self.provider = provider }

    public func get() -> Domain.EventsSorter {
        do {
            let data = try Data(contentsOf: provider.url)
            let sorter = try Self.decoder.decode([EventsSorter].self, from: data)
            return sorter.first!
        } catch {
            return .alphabetical
        }
    }

    public func set(_ sorter: Domain.EventsSorter) {
        do {
            let data = try Self.encoder.encode([sorter])
            try data.write(to: provider.url)
        } catch {
            fatalError(String(describing: error))
        }
    }
}
