//
//  Button.swift
//  trackto
//
//  Created by Andrew Platkin on 9/21/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class SlateButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = Config.slateColor
        self.setTitleColor(Config.whiteColor, forState: UIControlState.Normal)
    }
    
    func setupButton(text: String, target: AnyObject, action: Selector) {
        self.setTitle(text, forState: UIControlState.Normal)
        self.targetForAction(action, withSender: target)
    }

}
