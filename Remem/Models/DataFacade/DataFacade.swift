//
//  DataFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class DataFacade {
    private let entriesService = EntriesService()
    private let pointsService = PointsService()
}

// MARK: - Public
extension DataFacade {
    func getEntriesAmount() -> Int {
        entriesService.fetch()
        return entriesService.getAmount()
    }

    func entry(at index: Int) -> Entry? { return entriesService.entry(at: index) }

    func entry(by id: String) -> Entry? { return entriesService.entry(by: id) }

    @discardableResult
    func makeEntry(name: String) -> Entry { return entriesService.make(name: name) }

    @discardableResult
    func makePoint(at entry: Entry, dateTime: Date) -> Point {
        return entriesService.makePoint(at: entry, dateTime: dateTime)
    }

    func getPointsAmount() -> Int { return pointsService.getTotalPointsAmount() }

    func getPoints(for entry: Entry, between start: Date, and end: Date) -> [Point] {
        pointsService.getPoints(for: entry, between: start, and: end)
    }

    func getVisitedEntriesAmount() -> Int { return entriesService.getVisitedAmount() }

    func delete(entry: Entry) { entriesService.delete(entry) }

    func visit(entry: Entry) { entriesService.visit(entry) }
}
