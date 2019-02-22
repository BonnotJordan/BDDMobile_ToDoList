//
//  ViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var items = Array<ItemCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupConstraints()
    }
    //MARK: Actions
    func showAlert(isEditing: Bool = false, itemIndex: IndexPath? = nil) {
        if(isEditing) {
            if let itemIndex2 = itemIndex {
                let alertController = UIAlertController(title: "Doing", message: "Edit item ?", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Enter your todo"
                    textField.text = self.items[itemIndex2.item].name
                })
                let okAction = UIAlertAction(title: "Ok", style: .default) {
                    (action) in
                    let textField = alertController.textFields![0] as UITextField
                    let newItemText = textField.text!
                    if(!newItemText.isEmpty){
                        self.items[itemIndex2.item].name = newItemText
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
                    self.items.append(ItemCell(text: newItemText))
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
    
    //MARK: View Setup
    func setupConstraints() {
        /*navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true*/
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item : ItemCell){
        cell.accessoryType = item.isChecked ? .checkmark : .none
    }
    
    func configureText(for cell: UITableViewCell, withItem item: ItemCell) {
        cell.textLabel?.text = item.name
    }
    


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        configureText(for: cell, withItem: items[indexPath.item])
        configureCheckmark(for: cell,withItem: items[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.item].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            self.showAlert(isEditing: true, itemIndex: index)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            self.items.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        edit.backgroundColor = .lightGray
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    
}

