//
//  CoreDataConsumer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import CoreData

protocol CoreDataConsumer {
    var persistentContainer: NSPersistentContainer { get }
}
