//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Elliott on 17/06/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
         loadCategories()
        
        //MARK - Tableview Datasource methods
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let newCategory = categoryArray[indexPath.row]
        cell.textLabel?.text = newCategory.name
        return cell
        
    }

    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategories()
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Entry"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error fetching categories \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        
        do{
            try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }

}
