//
//  TagslistViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class TagslistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tags = Array<Tag>()
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        self.tags = self.appDelegate.loadContextTags()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
 

}

extension TagslistViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        //configureText(for: cell, withItem: filteredItems[indexPath.item] )
        //configureCheckmark(for: cell,withItem: filteredItems[indexPath.item] )
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            self.performSegue(withIdentifier: "editItem", sender: index)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            //            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            self.managedContext.delete(self.tags[indexPath.row])
            self.appDelegate.saveContext()
            self.tags = self.appDelegate.loadContextTags()
            
            tableView.reloadData()
            
        }
        
        edit.backgroundColor = .lightGray
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem"){
            let navigation = segue.destination as! UINavigationController
            let delegateVC = navigation.topViewController as! AddTagViewController
            delegateVC.delegate = self
        }
        else if (segue.identifier == "editItem"){
            let navigation = segue.destination as! UINavigationController
            let delegateVC = navigation.topViewController as! AddTagViewController
            delegateVC.indexPath = sender as! IndexPath
            delegateVC.tagToEdit = tags[(sender! as AnyObject).row]
            delegateVC.delegate = self
        }
    }
    
}

extension TagslistViewController : AddTagViewControllerDelegate {
    func addTagViewControllerDidCancel(_ controller: AddTagViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTagViewController(_ controller: AddTagViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func editTagViewController(_ controller: AddTagViewController, withTag tagEdit: Tag, atIndexPath indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
