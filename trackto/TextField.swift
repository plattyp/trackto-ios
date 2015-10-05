//
//  TextField.swift
//  trackto
//
//  Created by Andrew Platkin on 9/19/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class TextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeTextField()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        customizeTextField()
    }
    
    func customizeTextField() {
        self.text               = ""
        self.textColor          = Config.greenColor
        self.backgroundColor    = Config.lightGrayColor
        self.layer.borderWidth  = 1.0
        self.layer.borderColor  = Config.lightGrayColor.CGColor
        self.layer.cornerRadius = 5.0
        
        self.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func validatePresence() -> Bool {
        if (self.text == "") {
            self.backgroundColor = Config.redColor
            return false
        } else {
            self.backgroundColor = Config.lightGrayColor
            return true
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        validatePresence()
    }
}
