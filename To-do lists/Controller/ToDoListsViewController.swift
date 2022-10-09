//
//  ViewController.swift
//  To-do lists
//
//  Created by Djennelbaroud Hadj Cheikh on 20/06/2021.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework
class ToDoListsViewController: UITableViewController, SwipeTableViewCellDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var messionToDo = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory:Category? {
        didSet{
            
            loadTasks()
        }
    }
    var initialDurationText : String?
    var initialPriorityText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.name
        self.hideKeyboardWhenTappedAround()
        
        tableView.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: tableView.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ))
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "MissionCell")
        //        searchBar.barTintColor = FlatWatermelonDark()
        searchBar.barTintColor = ContrastColorOf(FlatWatermelonDark(), returnFlat: true)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: UIBarButtonItem) {
        var taskName : String?
        var amount :   String?
        var taskPriority : String?
        let alert = UIAlertController(title: "ADD A TASK TO DO", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (taskNameTF ) in
            taskNameTF.placeholder = "Task name"
            taskNameTF.returnKeyType = .join
        }
        alert.addTextField { (AmountOfTimeTF) in
            AmountOfTimeTF.placeholder = "The amount of time"
            AmountOfTimeTF.returnKeyType = .join
        }
        alert.addTextField { (priority) in
            priority.placeholder = "Priority from 1 to 5"
            priority.returnKeyType = .join
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { (alertAction) in
            taskName = alert.textFields![0].text
            amount = alert.textFields![1].text
            taskPriority = alert.textFields![2].text
            //            let TaskToAdd2 = Task(name: taskName, amountOfTime: amount, priority: taskPriority,done: false)
            let TaskToAdd = Task(context: self.context)
            TaskToAdd.name = taskName
            TaskToAdd.amountOfTime = amount
            TaskToAdd.priority = taskPriority
            TaskToAdd.done = false
            TaskToAdd.parentCategory = self.selectedCategory
            self.messionToDo.append(TaskToAdd)
            self.saveTask()
            //            self.defaults.set(try? PropertyListEncoder().encode(self.messionToDo), forKey:"messionToDoArr")
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in
            
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
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
            messionToDo = try context.fetch(request)
        }catch{
            print("Error when trying to retreive task from database")
        }
        tableView.reloadData()
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
    //MARK: - Table view methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messionToDo.count 
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissionCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        let mession = messionToDo[indexPath.row]
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
            
            self.context.delete(self.messionToDo[indexPath.row])
            self.messionToDo.remove(at: indexPath.row)
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
                self.messionToDo[indexPath.row].name = taskName
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
        messionToDo[indexPath.row].done = !messionToDo[indexPath.row].done
        saveTask()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}



//MARK: - Search bar delegate
extension ToDoListsViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        let name = searchBar.text
        if name != ""{
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", name!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            loadTasks(with: request,predicate: predicate)
        }else{
            searchBar.placeholder = "the field still empty"
            return
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            let predicate = NSPredicate(format : "parentCategory.name MATCHES %@",selectedCategory!.name!)
            loadTasks(predicate : predicate)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            searchBar.placeholder = "Search for task"
        }
        
    }
    
}


extension ToDoListsViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 1 {
            initialDurationText = textView.text
            
        }else{
            initialPriorityText = textView.text
        }
        
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 1 {
            for row in messionToDo {
                if row.amountOfTime == initialDurationText {
                    row.amountOfTime = textView.text
                    DispatchQueue.main.async {
                        textView.resignFirstResponder()
                    }
                }
                
                
            }
            
        }else{
            for row in messionToDo {
                if row.priority == initialPriorityText {
                    row.priority = textView.text
                    DispatchQueue.main.async {
                        textView.resignFirstResponder()
                    }
                }
                
            }
            
        }
        
        saveTask()
        textView.textAlignment = .center
        return true
    }
    
    
    
}

