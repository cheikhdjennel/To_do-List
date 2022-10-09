//
//  InProgressTasksTableViewController.swift
//  To-do lists
//
//  Created by Cheikh on 8/10/2022.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class InProgressTasksTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var inProgressTasks = [Task]()
    var selectedCategory : Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\nView did load of in progress tasks called\n")
        view.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: view.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: Constants.CellsIdentifiers.taskCell)
        tableView.allowsMultipleSelection = true
        
        loadInProgressTasks()
//        loadTasks()
        
    }
    
    // MARK: - Add, load and save tasks functions
    
    func addTask(task : Task){
        self.inProgressTasks.append(task)
        self.saveTask()
    }
    
    func loadTasks(with request : NSFetchRequest<Task> = Task.fetchRequest(), predicate :NSPredicate? = nil) {
        let Categorypredicate = NSPredicate(format:"parentCategory.name MATCHES %@",selectedCategory!.name!)
        if let additionlSearchPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,additionlSearchPredicate])
            request.predicate = compoundPredicate
        }else{
            request.predicate = Categorypredicate
        }
        
        do{
            inProgressTasks = try context.fetch(request)
        }catch{
            print("Error when trying to retreive task from database")
        }
        
        self.tableView.reloadData()
    }
    
    func loadInProgressTasks() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: "done == false")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            loadTasks(with: request,predicate: predicate)
        
    }
    
    func updateTaskStatut(){
        do{
            try  context.save()
        }catch{
            print("Error while updating context")
        }
        loadInProgressTasks()
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
        return inProgressTasks.count
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissionCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        let mession = inProgressTasks[indexPath.row]
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
            
            self.context.delete(self.inProgressTasks[indexPath.row])
            self.inProgressTasks.remove(at: indexPath.row)
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
                self.inProgressTasks[indexPath.row].name = taskName
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
        inProgressTasks[indexPath.row].done = !inProgressTasks[indexPath.row].done
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
        }
        
    }
 
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        inProgressTasks[indexPath.row].done = !inProgressTasks[indexPath.row].done
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
        
    }
    
}
