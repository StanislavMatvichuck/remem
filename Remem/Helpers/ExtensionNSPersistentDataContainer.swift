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
}

extension NSPersistentStoreCoordinator {
    func clearInMemoryStore() {
        let coordinator = self
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
            print(error.localizedDescription)
        }
    }
}
