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

    func fetch(from: Date, to: Date) -> [Point] {
        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = makeBoundedPredicate(from: from, to: to)

        do {
            let points = try moc.fetch(request)

            daySectionsList.reset()
            nightSectionsList.reset()

            for point in points {
                daySectionsList.addPoint(with: point.dateCreated!)
                nightSectionsList.addPoint(with: point.dateCreated!)
            }

            return points
        } catch {
            print("PointsListService.fetchCount() error \(error)")
            return []
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

    private func makeBoundedPredicate(from: Date, to: Date) -> NSPredicate {
        let calendar = Calendar.current
        var componentsFrom = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: from)
        componentsFrom.hour = 00
        componentsFrom.minute = 00
        componentsFrom.second = 00

        var componentsTo = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: to)
        componentsTo.hour = 23
        componentsTo.minute = 59
        componentsTo.second = 59

        let startDate = calendar.date(from: componentsFrom)
        let endDate = calendar.date(from: componentsTo)

        let format = "entry == %@ AND dateCreated >= %@ AND dateCreated =< %@"
        return NSPredicate(format: format, argumentArray: [entry, startDate!, endDate!])
    }
}
