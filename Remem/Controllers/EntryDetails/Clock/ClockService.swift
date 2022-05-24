//
//  ClockService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 16.05.2022.
//

import CoreData

class ClockService {
    // MARK: - Public properties
    let nightSectionsList = ClockSectionDescriptionsList(start: .makeStartOfDay(), end: .makeMidday(), stitchesPer24h: 144)
    let daySectionsList = ClockSectionDescriptionsList(start: .makeMidday(), end: .makeEndOfDay(), stitchesPer24h: 144)

    // MARK: - Properties
    private var entry: Entry
    private var coreDataStack: CoreDataStack
    private var moc: NSManagedObjectContext

    // MARK: - Init
    init(_ entry: Entry, stack: CoreDataStack) {
        self.entry = entry
        moc = entry.managedObjectContext!
        coreDataStack = stack
    }
}

// MARK: - Public
extension ClockService {
    func fetch() {
        daySectionsList.reset()
        nightSectionsList.reset()

        let points = fetchPoints()
        for point in points {
            daySectionsList.addPoint(with: point.dateCreated!)
            nightSectionsList.addPoint(with: point.dateCreated!)
        }
    }
}

// MARK: - Private
extension ClockService {
    private func fetchPoints() -> [Point] {
        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = NSPredicate(format: "entry == %@", argumentArray: [entry])

        do { return try moc.fetch(request) } catch {
            print("PointsListService.fetchCount() error \(error)")
            return []
        }
    }
}
