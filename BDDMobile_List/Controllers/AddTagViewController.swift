//
//  AddTagViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AddTagViewController: UIViewController {
    
    var delegate : AddTagViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        delegate?.addTagViewControllerDidCancel(self)
    }
    
    @IBAction func onDone(_ sender: Any) {
        delegate?.addTagViewController(self)
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
