//
//  HappeningsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class HappeningsRepository {
    private let coreDataStack = CoreDataStack()
    private var calendar: Calendar { .current }
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension HappeningsRepository {
    func getTotalHappeningsAmount() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Happening")
        fetchRequest.resultType = .countResultType

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("Unable to fetch happenings amount: \(error), \(error.userInfo)")
            return 0
        }
    }

    func getHappenings(for event: CDEvent, between start: Date, and end: Date) -> [CDHappening] {
        guard
            let start = makeStartOfTheDay(for: start),
            let end = makeEndOfTheDay(for: end)
        else { fatalError("HappeningsService.getHappenings invalid date") }

        let format = "event == %@ AND dateCreated >= %@ AND dateCreated =< %@"
        let predicate = NSPredicate(format: format, argumentArray: [event, start, end])

        let request = CDHappening.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDHappening.dateCreated), ascending: false)]
        request.predicate = predicate

        do {
            return try moc.fetch(request)
        } catch {
            print("HappeningsService.getHappenings() error \(error)")
            return []
        }
    }
}

// MARK: - Private
extension HappeningsRepository {
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
