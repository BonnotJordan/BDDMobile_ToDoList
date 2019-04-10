//
//  AddItemViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 01/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData
import SearchTextField

class AddItemViewController: UIViewController {

    var delegate : AddItemViewControllerDelegate?
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var itemToEdit : Item?
    var indexPath : IndexPath?
    var search : SearchTextField?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        if(itemToEdit != nil){
            self.title = "Edit an item"
            nameTextField.text = itemToEdit?.name
        } else {
            self.title = "Add an item"
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if(itemToEdit == nil){
            let newItem = Item(context: managedContext)
            newItem.name = nameTextField.text
            newItem.desc = descriptionTextField.text
            /*let category = Category(context: managedContext)
             category.name = categoryTextField.text
             newItem.category = category*/
            
            print(newItem)
            delegate?.addItemViewController(self)
        } else {
            itemToEdit?.name = nameTextField.text!
            delegate?.editItemViewController(self, withItem: itemToEdit!, atIndexPath: indexPath!)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController)
    func editItemViewController(_ controller: AddItemViewController, withItem itemEdit: Item, atIndexPath indexPath: IndexPath)
}
