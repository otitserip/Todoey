//
//  ViewController.swift
//  Todoey
//
//  Created by Tito Pires on 17/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems :  Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
      
        //loadItems()
 
    }

    
    //MARK: -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        //ternary operator =>
        //value =  condition ? TrueValue : FalseValue
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tems added"
        }
            
            
            
        
        return cell
        
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
                
            } catch {
                
                print("Error saving done status, \(error)")
            }
            
        }

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
            
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                        //item.done = !item.done
                    }
                    
                } catch {
                    
                    print("Error saving done status, \(error)")
                }
                
            }
            
            //update uitableview
            self.tableView.reloadData()
            
            
            
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
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            newItem.data = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving item: \(error)")
                    }
                }
                
                //update uitableview
                self.tableView.reloadData()

            }
  
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
                
    }

    
    
    //MARK: - Load Items
   
    func loadItems() {
       
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }


}


//MARK: - Search bar delegate methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "data", ascending: true)
        
        //update uitableview
        self.tableView.reloadData()
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



