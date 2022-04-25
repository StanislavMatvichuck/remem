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

    private var defaultContainer: NSPersistentContainer = { createContainer(inMemory: false) }()
    private var onboardingContainer: NSPersistentContainer = { createContainer(inMemory: true) }()

    var defaultContext: NSManagedObjectContext { defaultContainer.viewContext }
    var onboardingContext: NSManagedObjectContext { onboardingContainer.viewContext }
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

    static func createContainer(inMemory: Bool) -> NSPersistentContainer {
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

    func resetOnboardingContainer() {
        let coordinator = onboardingContainer.persistentStoreCoordinator
        guard let store = coordinator.persistentStores.first else { return }
        let storeURL = coordinator.url(for: store)

        do {
            if #available(iOS 15.0, *) {
                let storeType: NSPersistentStore.StoreType = .inMemory
                try coordinator.destroyPersistentStore(at: storeURL, type: storeType)
            } else {
                let storeType: String = NSInMemoryStoreType
                try coordinator.destroyPersistentStore(at: storeURL, ofType: storeType)
            }
        } catch {
            print(error.localizedDescription)
        }

        onboardingContainer = Self.createContainer(inMemory: true)
    }
}
