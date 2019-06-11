//
//  ViewController.swift
//  Todoey
//
//  Created by Elliott on 28/05/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    
    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (dataFilePath)
        
        loadItems()
            
        }
        

    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return itemArray.count
        
        
    }
    
    //Provides a cell object in each row
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Fetch a cell of the appropriate type.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //Created a variable for ease of use instead of typing the index path.
        
        let  newItem = itemArray[indexPath.row]
        
        //Configures Cells contents 
        
        cell.textLabel?.text = newItem.title
        
        //Ternary operator value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = newItem.checked == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods

    //Determines which row is selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Created a variable for ease of use instead of typing the index path.
        
        let item = itemArray[indexPath.row]
        
        //Un-checks the cell row.
        
        item.checked = !item.checked
        
        saveItems() 
        
        //reloads the table data to not roll over when scrolling.
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Text field local variable made so we can access the persistent data within the closure.
        
        var textField = UITextField()
        
        //created an alert to pop up when we click the add button.
        
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        //What the alert controller says in the text button.
        
        //let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen when the button is pressed
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Entry"
            textField = alertTextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("error encoding itemArray \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            try itemArray = decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding itemArray \(error)")
            } 
        }
    }
}
    
    

        



