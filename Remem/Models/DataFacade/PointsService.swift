//
//  PointsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class PointsService {
    private let coreDataStack = CoreDataStack()
    private var calendar: Calendar { .current }
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension PointsService {
    func getTotalPointsAmount() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Point")
        fetchRequest.resultType = .countResultType

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("Unable to fetch points amount: \(error), \(error.userInfo)")
            return 0
        }
    }

    func getPoints(for entry: Entry, between start: Date, and end: Date) -> [Point] {
        guard
            let start = makeStartOfTheDay(for: start),
            let end = makeEndOfTheDay(for: end)
        else { fatalError("PointsService.getPoints invalid date") }

        let format = "entry == %@ AND dateCreated >= %@ AND dateCreated =< %@"
        let predicate = NSPredicate(format: format, argumentArray: [entry, start, end])

        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = predicate

        do {
            return try moc.fetch(request)
        } catch {
            print("PointsService.getPoints() error \(error)")
            return []
        }
    }
}

// MARK: - Private
extension PointsService {
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
}
