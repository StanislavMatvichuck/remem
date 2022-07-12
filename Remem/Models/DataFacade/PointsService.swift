//
//  PointsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class PointsService {
    private let coreDataStack = CoreDataStack()
}

// MARK: - Public
extension PointsService {
    func getAmount() -> Int {
        let moc = coreDataStack.defaultContext

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
}
