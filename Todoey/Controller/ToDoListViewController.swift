//
//  ViewController.swift
//  Todoey
//
//  Created by Elliott on 28/05/2019.
//  Copyright © 2019 Elliott Lambert. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let  newItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = newItem.title
        
        //Ternary operator value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = newItem.checked == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        item.checked = !item.checked 
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            newItem.checked = false
            
            newItem.parentCategory = self.selectedCategory
            
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
            
           try context.save()
        
        }
        catch{
            
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            
        itemArray = try context.fetch(request)
            
        }
        catch{
            
            print("Error fetching Items \(error)")
            
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        
        
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
    

        



