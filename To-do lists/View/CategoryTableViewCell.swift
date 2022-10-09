//
//  SubTaskTableViewCell.swift
//  To-do lists
//
//  Created by Djennelbaroud Hadj Cheikh on 23/06/2021.
//

import UIKit
import SwipeCellKit
class CategoryTableViewCell: SwipeTableViewCell {

    

    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public static func nib() -> UINib{
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
}
