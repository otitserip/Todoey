//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tito Pires on 22/11/18.
//  Copyright © 2018 Tito Pires. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    
    var categories : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()

    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
  
    }
    
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    //MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
    
    //MARK: - Data Manipulation Methods
   
    //MARK: - Save to CoreData
    func save(category: Category) {
        
        do {
            try realm.write {
                    realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        //update uitableview
        self.tableView.reloadData()
        
    }
    
    //MARK: - Load Items
    func loadCategories() {
        
        categories = realm.objects(Category.self)
 
        tableView.reloadData()
        
    }
    
    
    
    
    //MARK: - Add New Categorys
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if !(textField.text?.isEmpty)! {
                
                let newCategory = Category()
                newCategory.name = textField.text!

                self.save(category: newCategory)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
 
    
}
