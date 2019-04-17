//
//  CategoriesTableViewController.swift
//  BDDMobile_List
//
//  Created by Brandon on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    var categories = Array<Category>()
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBAction func addCategory(_ sender: Any) {
        addCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        self.categories = self.appDelegate.loadContextCategories()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.categories = self.appDelegate.loadContextCategories()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorieCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    
    func addCategory(isEditing: Bool = false, itemIndex: IndexPath? = nil) {
        if(isEditing) {
            if let itemIndex2 = itemIndex {
                let alertController = UIAlertController(title: "Doing", message: "Edit category ?", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Enter your category"
                    textField.text = self.categories[itemIndex2.item].name
                })
                let okAction = UIAlertAction(title: "Ok", style: .default) {
                    (action) in
                    let textField = alertController.textFields![0] as UITextField
                    let newCategoryText = textField.text!
                    if(!newCategoryText.isEmpty){
                        self.categories[itemIndex2.item].name = newCategoryText
                        
                        self.appDelegate.saveContext()
                        self.categories = self.appDelegate.loadContextCategories()
                        
                        self.tableView.reloadData()
                    }
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Doing", message: "New category ?", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter your category"
            })
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (action) in
                let textField = alertController.textFields![0] as UITextField
                let newCategoryText = textField.text!
                if(!newCategoryText.isEmpty){
                    
                    
                    let category = Category(context: self.managedContext)
                    category.name = newCategoryText
                    
                    self.appDelegate.saveContext()
                    self.categories = self.appDelegate.loadContextCategories()
                    
                    self.tableView.reloadData()
                }
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addCategory(isEditing: true, itemIndex: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.managedContext.delete(self.categories[indexPath.row])
        self.appDelegate.saveContext()
        self.categories = self.appDelegate.loadContextCategories()
        
        tableView.reloadData()
    }
 
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
