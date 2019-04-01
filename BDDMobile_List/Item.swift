//
//  ItemCell.swift
//  BDDMobile_List
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import Foundation

class Item {
    var name: String
    var isChecked: Bool
    
    init(text: String, checked: Bool = false) {
        self.name = text
        self.isChecked = checked
    }
    
    func toggleChecked() {
        if(isChecked){
            self.isChecked  = false
        } else {
            self.isChecked = true
        }
    }
}
