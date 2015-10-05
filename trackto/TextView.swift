//
//  TextView.swift
//  trackto
//
//  Created by Andrew Platkin on 9/19/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class TextView: UITextView, UITextViewDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        customizeTextField()
    }
    
    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        customizeTextField()
    }
    
    func customizeTextField() {
        self.text               = ""
        self.textColor          = Config.greenColor
        self.backgroundColor    = Config.lightGrayColor
        self.layer.borderWidth  = 1.0
        self.layer.borderColor  = Config.lightGrayColor.CGColor
        self.layer.cornerRadius = 5.0
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
    
    func textViewDidChange(textView: UITextView) {
        validatePresence()
    }

}
