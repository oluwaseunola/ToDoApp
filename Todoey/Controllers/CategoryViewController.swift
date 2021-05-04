//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Seun Olalekan on 2021-04-27.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeCellViewController {

    
    var categoryArray : Results<Category>?
    
    
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        
        
        
        
    }
    
    
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "What would you like to add?", preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "new category"
            textField = UITextField
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { [self] (UIAlertAction) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorBackground = UIColor.randomFlat().hexValue()
            
            self.saveData(category: newCategory)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //    to write or create obects to our realm, we must call realm.write{realm.add(whatever you need to add)}
    
    func saveData(category: Category) {
        
        do{
            try realm.write{realm.add(category)}
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(for indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)}}catch{print(error)}
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Cell Category"
        
        if let hexColor = categoryArray?[indexPath.row].colorBackground{
            cell.backgroundColor = UIColor(hexString: (hexColor))
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (hexColor))!, returnFlat: true)
        }

        return cell
    }
    
}
