//
//  ClockService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 16.05.2022.
//

import CoreData

class ClockService {
    // MARK: - Properties
    private var entry: Entry
    private var coreDataStack: CoreDataStack
    private var moc: NSManagedObjectContext
    private var calendar: Calendar { .current }

    // MARK: - Init
    init(_ entry: Entry, stack: CoreDataStack) {
        self.entry = entry
        moc = entry.managedObjectContext!
        coreDataStack = stack
    }
}

// MARK: - Public
extension ClockService {
    func fetch(from: Date, to: Date) -> [Point] {
        let request = makeFetchRequest(from: from, to: to)
        let points = results(for: request)

        return points
    }
}

// MARK: - Private
extension ClockService {
    private func makeFetchRequest(from: Date, to: Date) -> NSFetchRequest<Point> {
        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = makeBoundedPredicate(from: from, to: to)
        return request
    }

    private func makeBoundedPredicate(from: Date, to: Date) -> NSPredicate {
        guard
            let start = makeStartOfTheDay(for: from),
            let end = makeEndOfTheDay(for: to)
        else { fatalError("could not process date") }

        let format = "entry == %@ AND dateCreated >= %@ AND dateCreated =< %@"
        return NSPredicate(format: format, argumentArray: [entry, start, end])
    }

    private func makeStartOfTheDay(for date: Date) -> Date? {
        var components = calendarComponents(for: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        return calendar.date(from: components)
    }

    private func makeEndOfTheDay(for date: Date) -> Date? {
        var components = calendarComponents(for: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }

    private func calendarComponents(for date: Date) -> DateComponents {
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }

    private func results(for request: NSFetchRequest<Point>) -> [Point] {
        do {
            return try moc.fetch(request)
        } catch {
            print("PointsListService.fetchCount() error \(error)")
            return []
        }
    }
}
