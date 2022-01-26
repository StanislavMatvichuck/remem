//
//  ExtensionNSManagedObjectContext.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.01.2022.
//

import CoreData

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void,
                 successBlock: (() -> Void)? = nil)
    {
        perform {
            block()
            do {
                try self.save()
                successBlock?()
            } catch {
                self.rollback()
            }
        }
    }
}
