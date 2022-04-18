//
//  EntryDetailsModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.04.2022.
//

import CoreData
import Foundation
import UIKit.UIApplication

protocol EntryDetailsModelInterface {
    var delegate: EntryDetailsModelDelegate? { get set }

    var pointsAmount: Int { get }
    func point(at: IndexPath) -> Point?

    var dayCellsAmount: Int { get }
    func dayInMonth(at: IndexPath) -> Int
    func cellKind(at: IndexPath) -> DayOfTheWeekCell.Kind
    func isTodayCell(at: IndexPath) -> Bool
    func cellAmount(at: IndexPath) -> Int?

    var name: String { get }
    var dayAverage: NSNumber { get }
    var weekAverage: NSNumber { get }
    var lastWeekTotal: NSNumber { get }
    var thisWeekTotal: NSNumber { get }

    func fetch()
}

protocol EntryDetailsModelDelegate: NSFetchedResultsControllerDelegate {}

class EntryDetailsModel: EntryDetailsModelInterface {
    var dayAverage: NSNumber { entry.dayAverage as NSNumber }
    var weekAverage: NSNumber { entry.weekAverage as NSNumber }
    var lastWeekTotal: NSNumber { entry.lastWeekTotal as NSNumber }
    var thisWeekTotal: NSNumber { entry.thisWeekTotal as NSNumber }

    //

    // MARK: - Public properties

    //

    private let moc: NSManagedObjectContext

    weak var delegate: EntryDetailsModelDelegate?

    var pointsAmount: Int { fetchedResultsController?.fetchedObjects?.count ?? 0 }

    var name: String { entry.name ?? "_" }

    //

    // MARK: - Private properties

    //

    private var fetchedResultsController: NSFetchedResultsController<Point>?

    func fetch() {
        let request = NSFetchRequest<Point>(entityName: "Point")

        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]

        let predicate = NSPredicate(format: "entry == %@", argumentArray: [entry])

        request.predicate = predicate

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = delegate

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
    }

    private let entry: Entry

    //
    // UICollectionView props
    //

    private var dataSize: Int

    private var headSize: Int

    private var tailSize: Int

    var dayCellsAmount: Int {
        headSize + dataSize + tailSize
    }

    private lazy var amountByDay: [DateComponents: Int] = {
        var result = [DateComponents: Int]()

        let points = fetchedResultsController?.fetchedObjects ?? []

        for point in points {
            let date = point.dateCreated!

            let dateComponents = dateComponents(for: date)

            if let existingValue = result[dateComponents] {
                result.updateValue(existingValue + Int(point.value), forKey: dateComponents)
            } else {
                result.updateValue(Int(point.value), forKey: dateComponents)
            }
        }

        return result
    }()

    //

    // MARK: - Initialization

    //

    init(_ relatedEntry: Entry) {
        moc = relatedEntry.managedObjectContext!
        entry = relatedEntry

        let dateCreated = relatedEntry.dateCreated!

        let dateToday = Date.now

        let daysDelta = Calendar.current.numberOfDaysBetween(dateCreated, and: dateToday)

        dataSize = daysDelta

        headSize = {
            if dateCreated.weekdayNumber.rawValue == 1 {
                return 6
            }

            return dateCreated.weekdayNumber.rawValue - 2
        }()

        tailSize = {
            if dateToday.weekdayNumber.rawValue == 1 {
                return 0
            }

            return 8 - dateToday.weekdayNumber.rawValue
        }()
    }

    //

    // MARK: - Behaviour

    //

    private func dateComponents(for dataIndex: Int) -> DateComponents {
        let amountOfDaysToSubtract = dataSize - dataIndex - 1

        let date = Calendar.current.date(byAdding: .day, value: -amountOfDaysToSubtract, to: Date.now)

        return dateComponents(for: date!)
    }

    private func dateComponents(for date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: date)
    }

    private func amount(for dateComponent: DateComponents) -> Int {
        if let value = amountByDay[dateComponent] {
            return value
        } else {
            return 0
        }
    }

    private func amount(for dataIndex: Int) -> Int {
        let dateComponent = dateComponents(for: dataIndex)

        return amount(for: dateComponent)
    }

    func point(at indexPath: IndexPath) -> Point? {
        fetchedResultsController?.object(at: indexPath)
    }

    func dayInMonth(at indexPath: IndexPath) -> Int {
        let index = indexPath.row

        let todayIndex = dayCellsAmount - tailSize - 1

        let today = Date.now

        let daysDelta = todayIndex - index

        let nextDate = Calendar.current.date(byAdding: .day, value: -daysDelta, to: today)!

        let nextDay = Calendar.current.dateComponents([.day], from: nextDate).day!

        return nextDay
    }

    func cellKind(at indexPath: IndexPath) -> DayOfTheWeekCell.Kind {
        let index = indexPath.row

        if headSize == 0, index == 0 {
            return .data
        }

        if index < headSize - 1 {
            return .past
        }

        if index < headSize {
            return .created
        }

        if index == dayCellsAmount - tailSize {
            return .today
        }

        if index > dayCellsAmount - tailSize {
            return .future
        }

        return .data
    }

    func isTodayCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row == dayCellsAmount - tailSize - 1
    }

    func cellAmount(at indexPath: IndexPath) -> Int? {
        let index = indexPath.row

        let dataIndex = index - headSize

        return amount(for: dataIndex)
    }
}
