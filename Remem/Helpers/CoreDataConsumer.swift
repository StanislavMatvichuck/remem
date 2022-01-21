//
//  CoreDataConsumer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import CoreData
import UIKit

protocol CoreDataConsumer: UIViewController {
    var persistentContainer: NSPersistentContainer! { get }
}
