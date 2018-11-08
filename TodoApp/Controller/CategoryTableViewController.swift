//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Anirudh V on 11/7/18.
//  Copyright © 2018 Anirrudh. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier:"ToDo" , sender: Any?.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.selection = categories[indexPath.row]
            
        }
    }


    @IBAction func addButton(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add categories to your list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newcategory = Category(context: self.context)
            newcategory.name = textfield.text!
            self.categories.append(newcategory)
            
           
           self.save()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert,animated: true,completion: nil)
    }
    func save(){
        do{
            try context.save()
        }  catch{
                print(error)
            }
                
            tableView.reloadData()
        
    }
    
    func load(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch{
            print(error)
        }
        tableView.reloadData()
    }

}
