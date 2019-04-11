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
import TaggerKit

class AddItemViewController: UIViewController {

    var delegate : AddItemViewControllerDelegate?
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var itemToEdit : Item?
    var indexPath : IndexPath?
    var tagCollection = TKCollectionView()
    var tagCollectionSelected = TKCollectionView()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: SearchTextField!
    @IBOutlet weak var tagsTextField: TKTextField!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var selectedTagView: UIView!
    var tags = Array<Tag>()
    var tmpTags = Array<Tag>()
    
    
    
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
        
        categoryTextField.filterStrings(["Hello","Bonjour","Bonswer","Hola"])
        
        
        add(tagCollection, toView: tagView)
        tagCollection.tags = ["Some", "Tag", "For", "You"]
        
        add(tagCollectionSelected, toView: selectedTagView)
        tagCollectionSelected.tags = []
        
        tagCollectionSelected.action = .removeTag
        
        
        tagsTextField.sender = tagCollection
        tagsTextField.receiver = tagCollectionSelected
        
        tagCollection.action = .addTag
        tagCollection.receiver = tagCollectionSelected
        
        tagCollection.delegate = self
        tagCollectionSelected.delegate = self
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    override func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
        let newTag = Tag(context: managedContext)
        newTag.name = name
        tmpTags.append(newTag)
    }
    
    override func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if(itemToEdit == nil){
            if(nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty) {
                let alert = UIAlertController(title: "Impossible", message: "Veuillez remplir au moins le titre et la description", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let newItem = Item(context: managedContext)
                newItem.name = nameTextField.text
                newItem.desc = descriptionTextField.text
                let category = Category(context: managedContext)
                category.name = categoryTextField.text
                newItem.category = category
                
                print(newItem)
                delegate?.addItemViewController(self)
            }
            
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
