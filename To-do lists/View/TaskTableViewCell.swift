//
//  TaskTableViewCell.swift
//  To-do lists
//
//  Created by Djennelbaroud Hadj Cheikh on 20/06/2021.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
class TaskTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        priority.layer.borderWidth = 0.5
        priority.layer.cornerRadius = 8.0
        priority.clipsToBounds = true
        duration.layer.borderWidth = 0.5
        duration.layer.cornerRadius = 8.0
        duration.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    public static func nib() -> UINib{
        return UINib(nibName: "TaskTableViewCell", bundle: nil)
    }
    
}

