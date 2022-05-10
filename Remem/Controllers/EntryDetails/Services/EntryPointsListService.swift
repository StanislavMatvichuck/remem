//
//  EntryPointsListService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
import Foundation

class EntryPointsListService {
    // MARK: - Public properties
    var points: [Point] = []
    var count: Int { points.count }
    // MARK: - Private properties
    private let entry: Entry
    private let moc: NSManagedObjectContext
    // MARK: - Init
    init(_ entry: Entry) {
        self.entry = entry
        moc = entry.managedObjectContext!
    }
}

// MARK: - Public
extension EntryPointsListService {
    func fetch() {
        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = NSPredicate(format: "entry == %@", argumentArray: [entry])

        do { points = try moc.fetch(request) } catch {
            print("EntryPointsListService.fetchCount() error \(error)")
        }
    }

    func point(at index: IndexPath) -> Point? {
        let index = index.row
        guard index < points.count else { return nil }
        return points[index]
    }
}
