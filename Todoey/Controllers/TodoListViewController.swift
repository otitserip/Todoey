//
//  ViewController.swift
//  Todoey
//
//  Created by Tito Pires on 17/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
      
        loadItems()
 
    }

    
    //MARK: -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator =>
        //value =  condition ? TrueValue : FalseValue
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        //delete - tem que ser por estaa ordem
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        //save to context actualizar a checkmark
       saveItems()
        
        //update uitableview
        self.tableView.reloadData()
        
    
        //retira a barra azul constante quando selected, fica cinzento e depopis desaparece
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            //delete - tem que ser por estaa ordem
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            //save to context actualizar a checkmark
            saveItems()
            
            
            
        }
    }
    
 
    
    //MARK: - Add New Items Section
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert =  UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will open once user clicks teh add item button on UIAlert
            //print(textField.text)
            if !(textField.text?.isEmpty)! {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                //save to item.plist
               self.saveItems()
            }
  
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
                
    }

    
    //MARK: - Save to Item Plist
    func saveItems() {
        
       
        do {
           try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //update uitableview
        self.tableView.reloadData()
        
    }
    
    //MARK: - Load Items
    // with  - external parameters
    // request -  internal parameter
    // = - default value, quando nao é usado parametros, assume valor default
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate  = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
             request.predicate = categoryPredicate
        }
        
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        
      tableView.reloadData()
        
    }


}


//MARK: - Search bar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request, predicate: predicate)
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            //para desaparecer o keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}





