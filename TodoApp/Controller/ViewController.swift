//
//  ViewController.swift
//  TodoApp
//
//  Created by Anirudh V on 11/6/18.
//  Copyright © 2018 Anirrudh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
   
    override func viewDidLoad() {
        
        
       load()
        
     
        
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
        
       itemArray[indexPath.row].check = !item.check
      save()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add items to your list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newitem = Item()
            newitem.title = textfield.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("error")
        }
    }
    
    func load(){
        if let data = try? Data(contentsOf: dataFilePath!)
       {
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            print("Error")
        }
        }
}
    }


