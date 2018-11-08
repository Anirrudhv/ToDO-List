//
//  ViewController.swift
//  TodoApp
//
//  Created by Anirudh V on 11/6/18.
//  Copyright © 2018 Anirrudh. All rights reserved.
//

import UIKit
import CoreData
let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
class ViewController: UITableViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    var selection: Category?{
        didSet {
            load()
        }
    }
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
   
    override func viewDidLoad() {
        
        searchBar.delegate = self
        
     
        
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
       let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.check ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let item = itemArray[indexPath.row]
      // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
       itemArray[indexPath.row].check = !item.check
      save()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add items to your list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newitem = Item(context: context)
            newitem.title = textfield.text!
            newitem.check = false
            newitem.parent = self.selection
            
            self.itemArray.append(newitem)
            self.save()
         
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textfield = alertTextField
            
        }
        alert.addAction(action)
            present(alert,animated: true,completion: nil)
        
    }
    
    func save(){
        
        do{
            try context.save()
        }
        catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func load(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
        
        let Categorypredicate = NSPredicate(format: "parent.name MATCHES %@", selection!.name!)
        
        if let additionalpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,additionalpredicate])
        }else{
            request.predicate = Categorypredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }
        catch{
            print(error)
            
        }
        tableView.reloadData()
}
    }

extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        load(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
