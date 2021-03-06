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
    @IBOutlet weak var addImageButton: UIButton!
    var tags = NSSet()
    var tmpTags = Array<Tag>()
    var tagsStr : Array<String> = Array<String>()
    var arrayStrEditTags = Array<String>()
    
    var previousTags = Array<Tag>()
    var previousTagsStr = Array<String>()
    var allTagsStrFromCoreData = [String]()
    var allCategoriesFromCoreData = [Category]()
    var allCategoriesStrFromCoreData = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        if(itemToEdit != nil){
            self.title = "Edit an item"
            nameTextField.text = itemToEdit?.name
            descriptionTextField.text = itemToEdit?.desc
            categoryTextField.text = itemToEdit?.category?.name
            previousTags = itemToEdit?.tags?.tags?.allObjects as! Array<Tag>
            let maxIndex = previousTags.count
            if(maxIndex > 0) {
                for index in 0...maxIndex-1 {
                    if(previousTags[index].name != nil){
                        let newTag = previousTags[index]
                        tmpTags.append(newTag)
                        previousTagsStr.append(newTag.name!)
                    }
                    
                }
            }
            
            
            
            let tags : Tags = itemToEdit!.tags!
            let tagsTags : NSSet = tags.tags!
            var tagArray : Array<Tag> = tagsTags.allObjects as! Array<Tag>
            let max = tagArray.count
            print("maxIndex \(max)")
            var tagsNameArray : Array<String> = Array<String>()
            
            if(max > 0){
                for i in 0...max-1 {
                    if(tagArray[i].name != nil){
                        let tagName = tagArray[i].name
                        tagsNameArray.append(tagName!)
                    }
                    
                }
            }
            
            
            
            tagCollectionSelected.tags = tagsNameArray
        } else {
            self.title = "Add an item"
            tagCollectionSelected.tags = []
        }
        
        allCategoriesFromCoreData = appDelegate.loadContextCategories()
        if(allCategoriesFromCoreData.count > 0){
            for i in 0...allCategoriesFromCoreData.count-1 {
                allCategoriesStrFromCoreData.append(allCategoriesFromCoreData[i].name!)
            }
        }
        
        categoryTextField.filterStrings(allCategoriesStrFromCoreData)
        
        
        add(tagCollection, toView: tagView)
        var tags = appDelegate.loadContextTags()
        
        for i in 0...tags.count-1 {
            allTagsStrFromCoreData.append(tags[i].name!)
        }
        tagCollection.tags = allTagsStrFromCoreData
        add(tagCollectionSelected, toView: selectedTagView)
        
        
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
        if(tagsStr.contains(name!) || previousTagsStr.contains(name!)){
        } else {
            if(allTagsStrFromCoreData.contains(name!)) {
                var tagsCoreData = appDelegate.loadContextTags()
                var index : Int?
                for i in 0...tagsCoreData.count-1 {
                    if(tagsCoreData[i].name == name! ) {
                        index = i
                    }
                }
                var tagAdded = tagsCoreData[index!]
                tmpTags.append(tagAdded)
            } else {
                print("pass here")
                tagsStr.append(name!)
                var tagAdded = Tag(context: managedContext)
                tagAdded.name = name
                tmpTags.append(tagAdded)
            }
            
            
        }
        
    }
    
    override func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
        let indexOfName = previousTagsStr.firstIndex(of: name!) // 0
        print("itemIndex \(index)")
        previousTagsStr.remove(at: indexOfName!)
        tmpTags.remove(at: indexOfName!)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            print("IT WORKS !")
        }
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
                if(allCategoriesStrFromCoreData.contains(categoryTextField.text!)){
                    var index : Int?
                    for i in 0...allCategoriesFromCoreData.count-1 {
                        if(allCategoriesFromCoreData[i].name == categoryTextField.text! ) {
                            index = i
                        }
                    }
                    var categoryAdded = allCategoriesFromCoreData[index!]
                    newItem.category = categoryAdded
                    
                } else {
                    let category = Category(context: managedContext)
                    category.name = categoryTextField.text
                    newItem.category = category
                }
                
                
                
                let tags2 = NSSet()
                tags = tags2.addingObjects(from: tmpTags) as NSSet
                
                let finalTags = Tags(context: managedContext)
                finalTags.tags = tags
                newItem.tags = finalTags
                print("NewItems.tags \(newItem.tags)")
                
                print(newItem)
                delegate?.addItemViewController(self)
            }
            
        } else {
            itemToEdit?.name = nameTextField.text!
            itemToEdit?.desc = descriptionTextField.text!
            let category = Category(context: managedContext)
            category.name = categoryTextField.text!
            itemToEdit?.category = category
            
            let tags2 = NSSet()
            tags = tags2.addingObjects(from: tmpTags) as NSSet
            
            let finalTags = Tags(context: managedContext)
            finalTags.tags = tags
            itemToEdit?.tags = finalTags
            
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
