//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Albert Yu on 6/21/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       ShoppingListController.shared.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        displayAddGroceryItemAlertController()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ShoppingListController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItemCell", for: indexPath) as? GroceryItemTableViewCell else {return UITableViewCell()}
        guard let groceryItem = ShoppingListController.shared.fetchedResultsController.fetchedObjects?[indexPath.row] else {return UITableViewCell()}
        cell.update(withGroceryItem: groceryItem)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                guard let groceryItem = ShoppingListController.shared.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
                ShoppingListController.shared.delete(groceryItem: groceryItem)
            }
        }
    }

}

extension ShoppingListTableViewController {
    func displayAddGroceryItemAlertController() {
        let alertController = UIAlertController(title: "Add item", message: "Please add an item to you shopping list", preferredStyle: .alert )
        alertController.addTextField {(textField) in
            textField.placeholder = "Grocery Item"
        }
        
        let addGroceryItemAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let groceryName = alertController.textFields?.first?.text, groceryName != " " else {return}
            ShoppingListController.shared.add(groceryItemWithName: groceryName)
            self.tableView.reloadData()
        }
        alertController.addAction(addGroceryItemAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension ShoppingListTableViewController: GroceryItemTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: GroceryItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        guard let groceryItem = ShoppingListController.shared.fetchedResultsController.fetchedObjects? [indexPath.row] else {return}
        ShoppingListController.shared.toggleIsCompleteFor(groceryItem: groceryItem)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}


extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}






