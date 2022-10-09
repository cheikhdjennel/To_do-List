//
//  DoneTasksTableViewController.swift
//  To-do lists
//
//  Created by Cheikh on 8/10/2022.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class DoneTasksTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var doneTasks = [Task]()
    var selectedCategory : Category? = nil
    var delegate : TaskListUpdated?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nView did load of done tasks called\n")
        
        view.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: view.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: Constants.CellsIdentifiers.taskCell)
        tableView.allowsMultipleSelection = true

//        loadTasks()
        loadDoneTasks()
        
    }
    
    // MARK: - load and save tasks functions
    func loadTasks(with request : NSFetchRequest<Task> = Task.fetchRequest(), predicate :NSPredicate? = nil) {
        let Categorypredicate = NSPredicate(format:"parentCategory.name MATCHES %@",selectedCategory!.name!)
        if let additionlSearchPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,additionlSearchPredicate])
            request.predicate = compoundPredicate
        }else{
            request.predicate = Categorypredicate
        }
        
        do{
            doneTasks = try context.fetch(request)
        }catch{
            print("Error when trying to retreive task from database")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.delegate?.updated()
        }
    }

    func loadDoneTasks() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@ AND done == %@",selectedCategory!.name!, true)
            let predicate = NSPredicate(format: "done == true")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            loadTasks(with: request,predicate: predicate)
    }

    func updateTaskStatut(){
        do{
            try  context.save()
        }catch{
            print("Error while updating context")
        }
        loadDoneTasks()
    }
    
    func saveTask()
    {
        do{
            try  context.save()
        }catch{
            print("Error while saving context")
        }
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks.count
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissionCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        let mession = doneTasks[indexPath.row]
        cell.taskName.text = mession.name
        cell.duration.text = mession.amountOfTime
        //        cell.duration.delegate = self
        //        cell.priority.delegate = self
        cell.priority.text = mession.priority
        cell.accessoryType = mession.done ? .checkmark : .none
        //        cell?.backgroundColor = UIColor(randomFlatColorOf:.dark)
        cell.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: cell.frame, andColors: [UIColor(randomFlatColorOf:.dark),UIColor(randomFlatColorOf:.dark)])
        cell.taskName.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.context.delete(self.doneTasks[indexPath.row])
            self.doneTasks.remove(at: indexPath.row)
            self.saveTask()
            
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let renameAction = SwipeAction(style: .default, title: "Rename") { action, indexPath in
            var taskName : String?
            let alert = UIAlertController(title: "RENAME TASK", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (taskNameTF ) in
                taskNameTF.placeholder = "Enter the new task name"
                taskNameTF.returnKeyType = .done
            }
            let action = UIAlertAction(title: "Rename", style: .default) { (alertAction) in
                taskName = alert.textFields![0].text
                self.doneTasks[indexPath.row].name = taskName
                self.saveTask()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
                
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // customize the action appearance
        renameAction.image = UIImage(systemName: "goforward")
        renameAction.backgroundColor = FlatBlackDark()
        
        return [deleteAction, renameAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\n SELECTED \n\n")
        doneTasks[indexPath.row].done = !doneTasks[indexPath.row].done
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        doneTasks[indexPath.row].done = !doneTasks[indexPath.row].done
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
        }
        
    }


}
