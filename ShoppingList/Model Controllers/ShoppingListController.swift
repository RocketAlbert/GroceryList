//
//  TaskController.swift
//  Task27
//
//  Created by Albert Yu on 6/19/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static let shared = ShoppingListController()
    
    let fetchedResultsController: NSFetchedResultsController<GroceryItem>
    
    init() {
        
        let fetchRequest: NSFetchRequest<GroceryItem> = GroceryItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "due", ascending: false)]
        
        let resultsController: NSFetchedResultsController<GroceryItem> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an arror performing the fetch!! \(error.localizedDescription)")
        }
    }
    
    func add(groceryItemWithName name: String) {
        let _ = GroceryItem(name: name)
        saveToPersistentStore()
        
    }
    
    func update(groceryItem: GroceryItem, name: String) {
        groceryItem.name = name
        saveToPersistentStore()
        
    }
    
    func delete(groceryItem: GroceryItem) {
        groceryItem.managedObjectContext?.delete(groceryItem)
        saveToPersistentStore()
    }
    
    func toggleIsCompleteFor(groceryItem: GroceryItem) {
        groceryItem.isComplete = !groceryItem.isComplete
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving to moc: \(error.localizedDescription)")
        }
    }
    
}
