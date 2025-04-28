//
//  DatabaseManager.swift
//  NewsReaderApp
//
//  Created by Екатерина Яцкевич on 27.04.25.
//

import Foundation
import CoreData

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init(modelName: String = "NewsModel") {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreData: не удалось загрузить store: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        let ctx = container.viewContext
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            print("CoreData save error: \(error)")
        }
    }
    
}
