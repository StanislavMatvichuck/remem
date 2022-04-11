//
//  ExtensionNSPersistentDataContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import CoreData

extension NSPersistentContainer {
    func saveContextIfNeeded() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func loadInMemoryStore() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        persistentStoreDescriptions = [description]

        loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
    }

    func loadSQLiteStore() {
        loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
    }

    func clearInMemoryStore() {
        let coordinator = persistentStoreCoordinator
        guard let store = coordinator.persistentStores.first else { return }
        let storeURL = coordinator.url(for: store)

        do {
            if #available(iOS 15.0, *) {
                let storeType: NSPersistentStore.StoreType = .inMemory
                try coordinator.destroyPersistentStore(at: storeURL, type: storeType)
            } else {
                let storeType: String = NSInMemoryStoreType
                try coordinator.destroyPersistentStore(at: storeURL, ofType: storeType)
                try coordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: storeURL, options: nil)
            }
        } catch {
            fatalError()
        }
    }
}
