//
//  AddItemViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 01/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController {

    var delegate : AddItemViewControllerDelegate?
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        let newItem = Item(context: managedContext)
        newItem.name = nameTextField.text
        print(newItem)
        //delegate?.addItemViewController(self, didFinishAddingItem: newItem)
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
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: Item)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: Item)
}
