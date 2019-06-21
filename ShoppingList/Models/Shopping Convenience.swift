import Foundation
import CoreData

extension GroceryItem {
    @discardableResult
    convenience init(name: String, due: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.due = due
    }
}
