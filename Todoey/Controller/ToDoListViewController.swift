//
//  ViewController.swift
//  Todoey
//
//  Created by Elliott on 28/05/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController  {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let  newItem = toDoItems?[indexPath.row] {
            cell.textLabel?.text = newItem.title
            cell.accessoryType = newItem.done == true ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No Item Added yet"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
                }catch{
                    print("error checking items \(error)")
                }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                
                        currentCategory.items.append(newItem)
                    }
                    }catch{
                        print("error saving new Items, \(error)"  )
                    }
            }
            self.tableView.reloadData()
        
        }
                    alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create New Entry"
                    textField = alertTextField
                    }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

    //MARK: - Search Bar Methods
    
extension ToDoListViewController: UISearchBarDelegate{
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar){

            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
                loadItems()

                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }


        




