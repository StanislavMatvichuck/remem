//
//  DomainFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import Foundation

class DomainFacade {
    private let dataFacade = DataFacade()
}

// MARK: - Public
extension DomainFacade {
    func getHintState() -> HintState {
        if getEntriesAmount() == 0 { return .empty }
        if getAllPointsAmount() == 0 { return .placeFirstMark }
        if getVisitedEntriesAmount() == 0 { return .pressMe }
        return .noHints
    }

    func getEntriesAmount() -> Int { dataFacade.getEntriesAmount() }

    func entry(at index: Int) -> Entry? { dataFacade.entry(at: index) }

    func entry(by id: String) -> Entry? { dataFacade.entry(by: id) }

    func getPoints(for entry: Entry) -> [Point] { dataFacade.getPoints(for: entry, between: entry.dateCreated!, and: .now) }

    @discardableResult
    func makeEntry(name: String) -> Entry { dataFacade.makeEntry(name: name) }

    @discardableResult
    func makePoint(for entry: Entry, dateTime: Date) -> Point {
        dataFacade.makePoint(at: entry, dateTime: dateTime)
    }

    func delete(entry: Entry) { dataFacade.delete(entry: entry) }
    func visit(entry: Entry) { dataFacade.visit(entry: entry) }

    func getPoints(for entry: Entry, between start: Date, and end: Date) -> [Point] {
        dataFacade.getPoints(for: entry, between: start, and: end)
    }
}

// MARK: - Internal
extension DomainFacade {
    private func getAllPointsAmount() -> Int { dataFacade.getAllPointsAmount() }

    private func getVisitedEntriesAmount() -> Int { dataFacade.getVisitedEntriesAmount() }
}
