//
//  GroceryItemTableViewCell.swift
//  ShoppingList
//
//  Created by Albert Yu on 6/21/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//



import UIKit

protocol GroceryItemTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: GroceryItemTableViewCell)
}

class GroceryItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groceryItemLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    var delegate: GroceryItemTableViewCellDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func completeButtonToggled(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
}

extension GroceryItemTableViewCell {
    func update(withGroceryItem groceryItem: GroceryItem) {
        groceryItemLabel.text = groceryItem.name
        updateButton(groceryItem.isComplete)
    }
    
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
