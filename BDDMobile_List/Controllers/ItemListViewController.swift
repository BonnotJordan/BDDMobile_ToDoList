//
//  ViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UIViewController {

    
    @IBOutlet weak var filterByButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var items = Array<Item>()
    var categories = [Category]()
    var filteredItems = Array<Item>()
    var managedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var sections = [String]()
    var isFilterByCategory = false
    var isFirstTapButton = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        self.items = self.appDelegate.loadContextItems()
        filteredItems = items
        self.tableView.reloadData()
        
        let categories = self.appDelegate.loadContextCategories()
        if(categories.count > 0){
            for i in 0...categories.count-1 {
                sections.append(categories[i].name!)
            }
        }
        
        self.categories = appDelegate.loadContextCategories()
        print(categories.count)
        // Do any additional setup after loading the view, typically from a nib.
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.items = self.appDelegate.loadContextItems()
        let categories = self.appDelegate.loadContextCategories()
        sections = [String]()
        if(categories.count > 0){
            for i in 0...categories.count-1 {
                sections.append(categories[i].name!)
            }
        }
        self.tableView.reloadData()
    }
    //MARK: Actions
    func showAlert(isEditing: Bool = false, itemIndex: IndexPath? = nil) {
        if(isEditing) {
            if let itemIndex2 = itemIndex {
                let alertController = UIAlertController(title: "Doing", message: "Edit item ?", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Enter your todo"
                    textField.text = self.filteredItems[itemIndex2.item].name
                })
                let okAction = UIAlertAction(title: "Ok", style: .default) {
                    (action) in
                    let textField = alertController.textFields![0] as UITextField
                    let newItemText = textField.text!
                    if(!newItemText.isEmpty){
                        self.items[itemIndex2.item].name = newItemText
                        
                        self.appDelegate.saveContext()
                        self.items = self.appDelegate.loadContextItems()
                        
                        self.filteredItems = self.items
                        self.tableView.reloadData()
                    }
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Doing", message: "New item ?", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter your todo"
            })
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                (action) in
                let textField = alertController.textFields![0] as UITextField
                let newItemText = textField.text!
                if(!newItemText.isEmpty){
                
                    
                    let item = Item(context: self.managedContext)
                    item.name = newItemText
                    item.checked = false

                    self.appDelegate.saveContext()
                    self.items = self.appDelegate.loadContextItems()
                    
                    
                    self.filteredItems = self.items
                    self.tableView.reloadData()
                }
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
        
        
        
        
       
        
    }
    
    @IBAction func addItem(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func filterByAction(_ sender: Any) {
        if(filterByButton.title == "Filter by categories"){
            filterByButton.title = "Filter by name"
            isFilterByCategory = true
            self.items = self.appDelegate.loadContextItems()
            let categories = self.appDelegate.loadContextCategories()
            sections = [String]()
            if(categories.count > 0){
                for i in 0...categories.count-1 {
                    sections.append(categories[i].name!)
                }
            }
            self.tableView.reloadData()
        } else {
            filterByButton.title = "Filter by categories"
            isFilterByCategory = false
            self.items = self.appDelegate.loadContextItems()
            let categories = self.appDelegate.loadContextCategories()
            sections = [String]()
            if(categories.count > 0){
                for i in 0...categories.count-1 {
                    sections.append(categories[i].name!)
                }
            }
            self.tableView.reloadData()
        }
        
        
        
        
        
        /*if(self.isFilterByCategory){
            if(filterByButton.title == "Filter by name"){
                filterByButton.title = "Filter by categories"
            } else {
                filterByButton.title = "Filter by name"
            }
            
            //tableView.reloadData()
            isFilterByCategory = false
        } else {
            if(filterByButton.title == "Filter by categories"){
                filterByButton.title = "Filter by name"
            } else {
                filterByButton.title = "Filter by categories"
            }
            
            
            //tableView.reloadData()
            isFilterByCategory = true

        }*/
    }
    //MARK: View Setup
    func setupConstraints() {
        /*navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true*/
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item : Item){
        cell.accessoryType = item.checked ? .checkmark : .none
    }
    
    func configureText(for cell: UITableViewCell, withItem item: Item) {
        cell.textLabel?.text = item.name
    }
    


}

extension ItemListViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFilterByCategory){
            print(section)
            let counter = self.items.filter( {$0.category!.name == self.categories[section].name }).count
            //print(counter)
            return counter
        }
        return filteredItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isFilterByCategory){
            if(sections.count > 0){
                return sections.count
            }
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(isFilterByCategory){
            if(self.sections.count > 0){
                //print(self.sections[section])
                return self.sections[section]
            }
            
        }
        return nil
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        if(isFilterByCategory){
            let categories = appDelegate.loadContextCategories()
            let names = items.filter( {$0.category!.name == categories[indexPath.row].name }).map({ return $0.name })
            //print(names)
            cell.textLabel?.text = names[indexPath.row]
            configureCheckmark(for: cell,withItem: filteredItems[indexPath.item] )
        } else {
            configureText(for: cell, withItem: filteredItems[indexPath.item] )
            configureCheckmark(for: cell,withItem: filteredItems[indexPath.item] )
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.item].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        self.managedContext.delete(items[indexPath.row])
        self.appDelegate.saveContext()
        self.items = self.appDelegate.loadContextItems()
        
        filteredItems = items
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            self.performSegue(withIdentifier: "editItem", sender: index)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            self.managedContext.delete(self.items[indexPath.row])
            self.appDelegate.saveContext()
            self.items = self.appDelegate.loadContextItems()
            
            self.filteredItems = self.items
            tableView.reloadData()
            
        }
        
        edit.backgroundColor = .lightGray
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredItems = searchText.isEmpty ? items : items.filter { ( item : Item) -> Bool in
            return item.name!.range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive], range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem"){
            let navigation = segue.destination as! UINavigationController
            let delegateVC = navigation.topViewController as! AddItemViewController
            delegateVC.itemToEdit = nil
            delegateVC.delegate = self
        }
        else if (segue.identifier == "editItem"){
            let navigation = segue.destination as! UINavigationController
            let delegateVC = navigation.topViewController as! AddItemViewController
            delegateVC.indexPath = sender as! IndexPath
            delegateVC.itemToEdit = items[(sender! as AnyObject).row]
            delegateVC.delegate = self
        }
    }
    
}

extension Item {
    func toggleChecked() {
        self.checked = !self.checked
    }
}

extension ItemListViewController : AddItemViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController) {
        self.appDelegate.saveContext()
        self.items = self.appDelegate.loadContextItems()
        self.filteredItems = self.items
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func editItemViewController(_ controller: AddItemViewController, withItem itemEdit: Item, atIndexPath indexPath: IndexPath ) {
        self.items[indexPath.row] = itemEdit
        
        self.appDelegate.saveContext()
        self.items = self.appDelegate.loadContextItems()
        
        self.filteredItems = self.items
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
}
