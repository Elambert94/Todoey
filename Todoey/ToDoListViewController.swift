//
//  ViewController.swift
//  Todoey
//
//  Created by Elliott on 28/05/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Aragorn", "Find Gimli", "Find Legolas"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        }
        
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //Provides a cell object in each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //Configures Cells contents
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview Delegate Methods

    //Determines which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    //checks to see if there is already a checkmark on the cell, if there is de-checkmark.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Text field local variable made to give the closure below a reference.
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            //what will happen when the button is pressed
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Entry"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

