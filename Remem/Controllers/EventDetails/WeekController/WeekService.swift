//
//  WeekService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData

class WeekService {
    enum CellVariant {
        case past
        case filled
        case today
        case future
    }

    // MARK: - Properties
    var daysAmount: Int { event.weeksSince * 7 }
    var todayIndexRow: Int { daysAmount + Date.now.weekdayNumber.europeanDayOfWeek - 8 }

    private var event: Event
    private var moc: NSManagedObjectContext
    private var calendar: Calendar { Calendar.current }

    // MARK: - Init
    init(_ event: Event) {
        self.event = event
        moc = event.managedObjectContext!
    }
}

// MARK: - Public
extension WeekService {
    func dayOfMonth(for index: IndexPath) -> Int? {
        let daysDifference = index.row - todayIndexRow
        if let resultDate = calendar.date(byAdding: .day,
                                          value: daysDifference,
                                          to: Date.now)
        {
            return calendar.dateComponents([.day], from: resultDate).day
        } else { return nil }
    }

    // TODO: load test
    func happeningsAmount(for index: IndexPath) -> Int? {
        let daysDifference = index.row - todayIndexRow
        guard let resultDate = calendar.date(byAdding: .day, value: daysDifference, to: Date.now) else { return nil }

        let request = NSFetchRequest<NSNumber>(entityName: "Point")
        request.predicate = makeDayPredicate(for: resultDate)
        request.resultType = .countResultType

        do {
            return try moc.fetch(request).first?.intValue
        } catch {
            print("happenings fetching error \(error)")
            return nil
        }
    }
}

// MARK: - Private
extension WeekService {
    private func makeDayPredicate(for date: Date) -> NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        let format = "entry == %@ AND dateCreated >= %@ AND dateCreated =< %@"
        return NSPredicate(format: format, argumentArray: [event, startDate!, endDate!])
    }
}
