//
//  ViewController.swift
//  Todoey
//
//  Created by Tito Pires on 17/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item()]
    
    let defaults = UserDefaults.standard

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items
            
        } else {
            
            let newItem = Item()
            newItem.title = "Find Mike"
            itemArray.append(newItem)
            
            let newItem1 = Item()
            newItem1.title = "Find Mike2"
            itemArray.append(newItem1)
            
            let newItem2 = Item()
            newItem2.title = "Find Mike3"
            itemArray.append(newItem2)
            
            let newItem3 = Item()
            newItem3.title = "Find Mike4"
            itemArray.append(newItem3)
            
        }
        
        
        
        
        
    }

    
    //MARK -Tableview Datasource Methods
    
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
    
    //MARK- Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
    
        //retira a barra azul constante quando selected, fica cinzento e depopis desaparece
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
 
    
    //MARK - Add New Items Section
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert =  UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will open once user clicks teh add item button on UIAlert
            //print(textField.text)
            if !(textField.text?.isEmpty)! {
                
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                //save to serdefaults
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
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
    
    
}

