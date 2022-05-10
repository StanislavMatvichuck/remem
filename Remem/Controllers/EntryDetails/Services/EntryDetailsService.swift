//
//  EntryDetailsModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.04.2022.
//

import CoreData
import Foundation
import UIKit.UIApplication

class EntryDetailsService {
    // MARK: - Properties
    var entry: Entry
    var coreDataStack: CoreDataStack
    var moc: NSManagedObjectContext

    // MARK: - Init
    init(_ entry: Entry, stack: CoreDataStack) {
        self.entry = entry
        moc = entry.managedObjectContext!
        coreDataStack = stack
    }
}

// MARK: - Public
extension EntryDetailsService {
    func markAsVisited() {
        entry.markAsVisited()
        coreDataStack.save(moc)
    }
}
