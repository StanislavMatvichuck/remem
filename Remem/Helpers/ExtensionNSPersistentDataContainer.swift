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
