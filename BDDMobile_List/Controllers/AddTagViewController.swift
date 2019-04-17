//
//  AddTagViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var delegate : AddTagViewControllerDelegate?
    var indexPath : IndexPath?
    var tagToEdit : Tag?
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        if(tagToEdit != nil){
            self.title = "Edit a Tag"
            nameTextField.text = tagToEdit?.name
        } else {
            self.title = "Create a tag"
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        delegate?.addTagViewControllerDidCancel(self)
    }
    
    @IBAction func onDone(_ sender: Any) {
        if(tagToEdit == nil){
            let newTag = Tag(context: managedContext)
            newTag.name = nameTextField.text
            delegate?.addTagViewController(self)
        } else {
            tagToEdit?.name = nameTextField.text!
            delegate?.editTagViewController(self, withTag: tagToEdit!, atIndexPath: indexPath!)
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

protocol AddTagViewControllerDelegate : class {
    func addTagViewControllerDidCancel(_ controller: AddTagViewController)
    func addTagViewController(_ controller: AddTagViewController)
    func editTagViewController(_ controller: AddTagViewController, withTag tagEdit: Tag, atIndexPath indexPath: IndexPath)
}
