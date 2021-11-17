//
//  CategoryTableViewController.swift
//  To-do lists
//
//  Created by Djennelbaroud Hadj Cheikh on 13/11/2021.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: UITableViewController,SwipeTableViewCellDelegate, UITextFieldDelegate {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        
        navigationController?.navigationBar.barTintColor = FlatWatermelonDark()
        navigationController?.navigationBar.tintColor = ContrastColorOf((navigationController?.navigationBar.barTintColor)!, returnFlat: true)
        navigationController?.toolbar.barTintColor = FlatWatermelonDark()
        self.hideKeyboardWhenTappedAround()
        navigationItem.title = "Categories"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf((navigationController?.navigationBar.barTintColor)!, returnFlat: true)]
        
        loadCategories()
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        tableView.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: tableView.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
    }
    
    
    @IBAction func AddCategoryTapped(_ sender: Any) {
        var categoryName : String?
        let alert = UIAlertController(title: "ADD CATEGORY", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (categoryNameTF ) in
            categoryNameTF.placeholder = "Enter the category name"
            categoryNameTF.returnKeyType = .done
            categoryNameTF.delegate = self
        }
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            categoryName = alert.textFields![0].text
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        //        cell.backgroundColor = UIColor(randomFlatColorOf:.dark)
        cell.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: cell.frame, andColors: [UIColor(randomFlatColorOf:.dark),UIColor(randomFlatColorOf:.dark)])
        let category = categoryArray[indexPath.row]
        cell.categoryName?.text = category.name
        cell.categoryName.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            self.saveCategories()
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let renameAction = SwipeAction(style: .default, title: "Rename") { action, indexPath in
            var categoryName : String?
            let alert = UIAlertController(title: "RENAME CATEGORY", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (categoryNameTF ) in
                categoryNameTF.placeholder = "Enter the new category Name"
                categoryNameTF.returnKeyType = .done
                categoryNameTF.delegate = self
            }
            let action = UIAlertAction(title: "Rename", style: .default) { (alertAction) in
                categoryName = alert.textFields![0].text
                self.categoryArray[indexPath.row].name = categoryName
                self.saveCategories()
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
        performSegue(withIdentifier: "CategoryToTasks", sender: self)
        
    }
    
    // MARK: - load and Save functions
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error when trying to retreive Category from database")
        }
        tableView.reloadData()
    }
    
    func saveCategories()
    {
        do{
            try  context.save()
        }catch{
            print("Error while saving context")
        }
        tableView.reloadData()
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestinationVC = segue.destination as! ToDoListsViewController
        if let index = tableView.indexPathsForSelectedRows?[0] {
            DestinationVC.selectedCategory = self.categoryArray[index.row]
            
            
        }
        
    }
    
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
