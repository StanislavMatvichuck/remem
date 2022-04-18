//
//  CoreDataStack.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 08.04.2022.
//

import CoreData
import Foundation

class CoreDataStack {
    private static let entries = "EntriesList"

    private static let model: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: entries, withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOf: url)!
        return mom
    }()

    private lazy var defaultContainer: NSPersistentContainer = { createContainer(inMemory: false) }()
    private lazy var onboardingContainer: NSPersistentContainer = { createContainer(inMemory: true) }()

    lazy var defaultContext: NSManagedObjectContext = { defaultContainer.viewContext }()
    lazy var onboardingContext: NSManagedObjectContext = { onboardingContainer.viewContext }()
}

// MARK: - Public
extension CoreDataStack {
    func save(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func createContainer(inMemory: Bool) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: CoreDataStack.entries, managedObjectModel: CoreDataStack.model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error { fatalError("Unresolved error \(error)") }
        })

        return container
    }
}
