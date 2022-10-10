//
//  TasksViewController.swift
//  To-do lists
//
//  Created by Cheikh on 8/10/2022.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class TasksViewController: UIViewController , TaskListUpdated {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let inProgressTasksTC = InProgressTasksTableViewController()
    let doneTasksTC = DoneTasksTableViewController()
    var selectedCategory:Category? {
        didSet{
            title = selectedCategory?.name
            inProgressTasksTC.selectedCategory = selectedCategory
            doneTasksTC.selectedCategory = selectedCategory
        }
    }
    
    //MARK: - UI
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func configSegmentedControl(){
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline).withSize(13) ]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline).withSize(16)]
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        segmentedControl.addTarget(self, action: #selector(selectedSegmentChanged), for: .valueChanged)
        //        setupUnderlineViewForSelectedSegView()
    }
    
    let underlineViewForSelectedSegView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.layer.cornerRadius = 2.0
        return v
    }()
    
    func setupUnderlineViewForSelectedSegView(){
        self.view.addSubview(underlineViewForSelectedSegView)
        layoutUnderlineViewForSelectedSegView()
    }
    
    var underlineViewLeadingConstraint : NSLayoutConstraint?
    let leadingConstantWhenDoneSegmentSelected = UIScreen.main.bounds.width/2
    
    func layoutUnderlineViewForSelectedSegView(){
        
        underlineViewLeadingConstraint = underlineViewForSelectedSegView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor, constant: 0.0)
        NSLayoutConstraint.activate([
            underlineViewForSelectedSegView.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            underlineViewForSelectedSegView.heightAnchor.constraint(equalToConstant: 4.0),
            underlineViewForSelectedSegView.topAnchor.constraint(equalTo: segmentedControl
                .bottomAnchor, constant: 1.0),
            underlineViewLeadingConstraint!
        ])
    }
    
    let tasksContainerView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    func setupTasksContainerView(){
        self.view.addSubview(tasksContainerView)
        layoutTasksContainerView()
    }
    
    func layoutTasksContainerView(){
        NSLayoutConstraint.activate([
            tasksContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksContainerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0.0),
            tasksContainerView.bottomAnchor.constraint(equalTo: toolBarView.topAnchor)
        ])
    }
    
    let toolBarView : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.alignment = .top
        v.spacing = 16.0
        return v
    }()
    
    let sortItemView : CustomToolbarItemView = {
        let v = CustomToolbarItemView(imgName: "icons8-tri-croissant-50", title: "Sort")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.itemButton.addTarget(self, action: #selector(sortByPriorityButtonTapped), for: .touchUpInside)
        return v
    }()
    
    let markAsDoneItemView : CustomToolbarItemView = {
        let v = CustomToolbarItemView(imgName: "icons8-tâche-terminée-50", title: "Mark as Done")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.itemButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        return v
    }()
    
    let clearItemView : CustomToolbarItemView = {
        let v = CustomToolbarItemView(imgName: "icons8-poubelle-vide-50", title: "Clear All")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.itemButton.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)

        return v
    }()
    
    
    func setupToolbar(){
        self.view.addSubview(toolBarView)
        let themeColor = UIColor(gradientStyle: .leftToRight, withFrame: view.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
        toolBarView.backgroundColor = themeColor
        toolBarView.addArrangedSubview(sortItemView)
        toolBarView.addArrangedSubview(markAsDoneItemView)
        toolBarView.addArrangedSubview(clearItemView)
        layoutToolbarView()
    }
    
        func layoutToolbarView(){
            NSLayoutConstraint.activate([
                toolBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                toolBarView.heightAnchor.constraint(equalToConstant: 90),
            ])
        }
    
//    let toolBarView : UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.isUserInteractionEnabled = true
//
//       return v
//    }()
//
//    let doneButton : UIButton  = {
//        let doneButton = UIButton()
//        doneButton.translatesAutoresizingMaskIntoConstraints = false
//        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
//        let img = UIImage(systemName: "checkmark.circle.fill")
//        let img2 = UIImage(named: "icons8-tâche-terminée-50")
//        doneButton.setBackgroundImage(img2, for: .normal)
//        doneButton.tintColor = .white
//        doneButton.isUserInteractionEnabled = true
//        return doneButton
//    }()
//
//    func setupToolbar(){

//        view.addSubview(toolBarView)
//        toolBarView.addSubview(doneButton)
//        layoutToolbarView()
//    }
//

    
    let activityIndicator : UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.widthAnchor.constraint(equalToConstant: 40).isActive = true
        a.heightAnchor.constraint(equalToConstant: 40).isActive = true
        a.backgroundColor = .white
        a.isHidden = true
       return a
    }()
    
    func setupActivityIndicatorView(){
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - View cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.name
        let themeColor = UIColor(gradientStyle: .leftToRight, withFrame: view.frame, andColors: [FlatWatermelonDark(),UIColor(randomFlatColorOf:.dark)])
        view.backgroundColor = themeColor
        doneTasksTC.delegate = self
        hideKeyboardWhenTappedAround()
        configSegmentedControl()
        setupToolbar()
        setupTasksContainerView()
        addChildVC(childViewController: inProgressTasksTC, toView: tasksContainerView)
        setupActivityIndicatorView()
    }
    
    //TODO: - select segmented control
    @objc func selectedSegmentChanged(_ sender:UISegmentedControl!){
        switch sender.selectedSegmentIndex {
        case 0 :
            print("\nIn Progress Segment has been selected \n")
            if self.children.first == doneTasksTC {
                self.removeChildVC(childViewController: doneTasksTC)
            }
            self.addChildVC(childViewController: inProgressTasksTC, toView: tasksContainerView)
            self.markAsDoneItemView.itemTitleLabel.text = "Mark as Done"
            UIView.animate(withDuration: 0.3) {
                self.underlineViewLeadingConstraint?.constant = 0.0
                self.view.layoutIfNeeded()
                
            }
        case 1 :
            print("\nDone Segment has been selected \n")
            if self.children.first == inProgressTasksTC {
                self.removeChildVC(childViewController: inProgressTasksTC)
            }
            self.addChildVC(childViewController: doneTasksTC, toView: tasksContainerView)
            self.markAsDoneItemView.itemTitleLabel.text = "Undone"
            UIView.animate(withDuration: 0.3) {
                self.underlineViewLeadingConstraint?.constant = self.leadingConstantWhenDoneSegmentSelected
                self.view.layoutIfNeeded()
            }
            
            
        default:
            print("default")
        }
    }
    
    //TODO: - Add a task
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
            self.inProgressTasksTC.addTask(task: TaskToAdd)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in
            
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //TODO: - Done Button Action
    @objc func doneButtonTapped() {
        print("\ndoneButtonTapped\n")
        if inProgressTasksTC.tableView.indexPathsForSelectedRows != nil && segmentedControl.selectedSegmentIndex == 0 {
            print("\nSome Tasks Cells are selected\n")
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            inProgressTasksTC.updateTaskStatut()
            doneTasksTC.updateTaskStatut()
            
        }else if doneTasksTC.tableView.indexPathsForSelectedRows != nil && segmentedControl.selectedSegmentIndex == 1 {
            print("\nSome Tasks Cells are selected\n")
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            doneTasksTC.updateTaskStatut()
            inProgressTasksTC.updateTaskStatut()
            
        }

    }
    //TODO: - Clear All Button Action
    @objc func clearAllButtonTapped() {
        if segmentedControl.selectedSegmentIndex == 0 {
            inProgressTasksTC.clearAll()
        }else{
            doneTasksTC.clearAll()
        }
    }
    
    //TODO: - Sort by priority Button Action
    @objc func sortByPriorityButtonTapped() {
        if segmentedControl.selectedSegmentIndex == 0 {
            inProgressTasksTC.loadInProgressTasks(sortBy: "priority")
        }else{
            doneTasksTC.loadDoneTasks(sortBy: "priority")
        }
    }
    
    func updated() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }

    }
    
}


protocol TaskListUpdated {
    
    func updated()
}
