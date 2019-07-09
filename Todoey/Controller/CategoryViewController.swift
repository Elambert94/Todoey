//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Elliott on 17/06/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    //MARK - Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no Categories added yet"
        return cell
    }

    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
            var textField = UITextField()
            let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                 let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category: newCategory)
            } 
        
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Entry"
            textField = alertTextField
        }
        
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
        
        
        
    }
    func loadCategories(){
        
        categories = realm.objects(Category.self )
        tableView.reloadData()
    }
    
    func save(category : Category){
        
        do{
            try realm.write {
                 realm.add(category)
            }
        }
        catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data
    
    override func updateModel(at indexPath: IndexPath) {
        
        super .updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch{
                print("error deleting categories \(error)")
            }
        }
    }

}
