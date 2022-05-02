//
//  HintsManager.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.05.2022.
//

import Foundation

class HintsManager {
    enum State {
        case empty
        case placeFirstMark
        case pressMe
        case noHints
    }

    // MARK: - Properties
    let service: EntriesListService
    // MARK: - Init
    init(service: EntriesListService) { self.service = service }

    // TODO: perform load testing for this method
    func fetchState() -> State {
        if service.dataAmount == 0 { return .empty }
        if service.fetchPointsCount() == 0 { return .placeFirstMark }
        if service.fetchVisitedEntries() == 0 { return .pressMe }
        return .noHints
    }
}
