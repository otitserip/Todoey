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

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        loadItems()
        
        
        
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
        
        //save item plist para actualizar a checkmark
       saveItems()
        
        //update uitableview
        self.tableView.reloadData()
        
    
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
    
    
    
    
    //MARK - Save to Item Plist
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Handling plist file: \(error)")
        }
        
        //update uitableview
        self.tableView.reloadData()
        
    }
    
     //MARK - Load Items
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
              itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding plist file: \(error)")
            }
            
        }

    }
        
    

}

