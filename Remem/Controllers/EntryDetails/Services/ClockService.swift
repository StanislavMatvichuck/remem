//
//  ClockService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 16.05.2022.
//

import CoreData

class ClockService {
    typealias ClockStitches = (day: [Clock.StitchVariant], night: [Clock.StitchVariant])
    // MARK: - Properties
    private var entry: Entry
    private var coreDataStack: CoreDataStack
    private var moc: NSManagedObjectContext
    private var segmentsCount: Int

    // MARK: - Init
    init(_ entry: Entry, stack: CoreDataStack, segmentsCount: Int) {
        self.entry = entry
        self.segmentsCount = segmentsCount * 2
        moc = entry.managedObjectContext!
        coreDataStack = stack
    }
}

// MARK: - Public
extension ClockService {
    func fetch() -> ClockStitches {
        var result = Array(repeating: 0, count: segmentsCount)
        for point in fetchPoints() {
            let index = index(for: point.dateCreated!)
            result[index] += 1
        }

        let half = segmentsCount / 2
        let nightArray = result[0 ..< half].map { Clock.StitchVariant.make(from: $0) }
        let dayArray = result[half ..< result.count].map { Clock.StitchVariant.make(from: $0) }

        return (day: dayArray, night: nightArray)
    }

    private func fetchPoints() -> [Point] {
        let request = Point.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Point.dateCreated), ascending: false)]
        request.predicate = NSPredicate(format: "entry == %@", argumentArray: [entry])

        do { return try moc.fetch(request) } catch {
            print("EntryPointsListService.fetchCount() error \(error)")
            return []
        }
    }
}

// MARK: - Private
extension ClockService {
    private func index(for date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let dayTotalSeconds = 24 * 60 * 60
        let secondsDelta = dayTotalSeconds / segmentsCount

        var index = 0
        var seconds = 60 * 60 * components.hour! + 60 * components.minute! + components.second!

        while seconds > secondsDelta {
            index += 1
            seconds -= secondsDelta
        }

        return index
    }
}
