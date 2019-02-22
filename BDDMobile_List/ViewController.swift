//
//  ViewController.swift
//  BDDMobile_List
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationBar.heightAnchor.constraint(equalToConstant: 44)
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor)
    }


}

