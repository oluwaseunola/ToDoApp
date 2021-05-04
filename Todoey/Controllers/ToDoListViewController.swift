//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewController: SwipeCellViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var itemContainer : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        searchBar.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
       
        if let colorHex = selectedCategory?.colorBackground{
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            searchBar.barTintColor = UIColor(hexString: colorHex)
            navBar.barTintColor = UIColor(hexString: colorHex)
        }
    }
    
    //MARK: - add new items
    
    @IBAction func NewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add item", message: "What would you like to add?", preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "new item"
            textField = UITextField
            }
        
        let add = UIAlertAction(title: "Add", style: .default) {(add) in
            
//            this is the create in CRUD, here we 1. first create a new item uing the context, the context is created by accessing the shared delegate and downcasting it as the AppDelegate, using this, you can now access the context
            
            if let currentCategory = self.selectedCategory{
               
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.name = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
                   
            }
            
            self.tableView.reloadData()

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        

        
    }
    
    //MARK: - add cells to tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemContainer?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
        let backColor = UIColor(hexString: selectedCategory!.colorBackground)
            if let item = itemContainer?[indexPath.row] {
               
                
                cell.textLabel?.text = item.name
                print(indexPath.row)
                
                        
                
                if let rowTotal = itemContainer?.count{
                    cell.backgroundColor =                 backColor!.flatten().darken(byPercentage: CGFloat(indexPath.row)/CGFloat(rowTotal))}
                let background = cell.backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(background!, returnFlat: true)
//                when you do type conversion calculations, change both individually into whatever type you need, then proceed to do whatever operation with them.
                    
    
                //        ternary operator helps cut down conditional code
                //        format is value = condition ? firstoption:secondoption
                        
                cell.accessoryType = item.checked ? .checkmark: .none}else{
                    cell.textLabel?.text = "No items added"
                }
        
                
        return cell
    
    }
    
    override func updateModel(for indexPath: IndexPath) {
        
        if let itemToDelete = itemContainer?[indexPath.row]{
            do{try realm.write{
                realm.delete(itemToDelete)
                
            }}catch{print(error)}
            }
    }
    
    //MARK: - add checkmark
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemContainer?[indexPath.row] {
            do{ try realm.write{item.checked = !item.checked}}catch{print(error)}
    
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        

        
    }
    
//    after creating our object and assigning it to the context, we must save the data and commit it to our persistent container. We achieve this through this save() function which we can call after we have committed to our persistent continer. We also want to reload the table view anytime we save,update, or delete.
    

    func loadItems(){
       
    
        itemContainer = selectedCategory?.items.sorted(byKeyPath:"dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        itemContainer = itemContainer?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath:"dateCreated", ascending: true)
       
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

