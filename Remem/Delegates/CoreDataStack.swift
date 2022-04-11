//
//  CoreDataStack.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 08.04.2022.
//

import CoreData
import Foundation

class CoreDataStack {
    private static var _model: NSManagedObjectModel?

    private static func model(name: String) throws -> NSManagedObjectModel {
        if _model == nil {
            _model = try loadModel(name: name, bundle: Bundle.main)
        }
        return _model!
    }

    private static func loadModel(name: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd") else {
            throw CoreDataError.modelURLNotFound(forResourceName: name)
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoreDataError.modelLoadingFailed(forURL: modelURL)
        }
        return model
    }

    enum CoreDataError: Error {
        case modelURLNotFound(forResourceName: String)
        case modelLoadingFailed(forURL: URL)
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer

        do {
            let model = try CoreDataStack.model(name: "EntriesList")
            container = NSPersistentContainer(name: "EntriesList", managedObjectModel: model)
        } catch {
            print("error \(error.localizedDescription)")
            container = NSPersistentContainer(name: "EntriesList")
        }

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unresolved error (error), (error.userInfo)")
            }
        })

        return container
    }()

    lazy var onboardingPersistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        let container: NSPersistentContainer

        do {
            let model = try CoreDataStack.model(name: "EntriesList")
            container = NSPersistentContainer(name: "EntriesList", managedObjectModel: model)
        } catch {
            print("error \(error.localizedDescription)")
            container = NSPersistentContainer(name: "EntriesList")
        }

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unresolved error (error), (error.userInfo)")
            }
        })

        return container
    }()
}
