//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Zdrenko Zigich on 28.07.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext { return self.persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        do {
            let taskList = try context.fetch(fetchRequest)
            return taskList
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    func save(_ taskName: String) {
        var taskList = fetchData()
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.title = taskName
        taskList.append(task)
        
        saveContext()
    }
    
    func update(_ taskName: String, index: Int) {
        let taskList = fetchData()
        let task = taskList[index]
        task.setValue(taskName, forKey: "title")
        
        saveContext()
    }
    
    func delete(_ taskName: Task, index: Int) {
        let taskList = fetchData()
        
        context.delete(taskList[index])
        saveContext()
    }
}

