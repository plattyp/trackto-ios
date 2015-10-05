//
//  HorizontalButtonGroup.swift
//  trackto
//
//  Created by Andrew Platkin on 9/21/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class HorizontalButtonGroup: UIView {
    
    var buttonOne: UIButton?
    var buttonTwo: UIButton?
    
    init(width: CGFloat, height: CGFloat, centerPoint: CGPoint) {
        let frame = CGRectMake(0, 0, width, height)
        super.init(frame: frame)
        self.center = centerPoint
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupButtonOne(target: AnyObject, action: Selector, title:String) {
        buttonOne = UIButton(frame: CGRectMake(0, 0, self.frame.width * 0.47, self.frame.height))
        buttonOne!.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        buttonOne!.setTitle(title, forState: UIControlState.Normal)
        buttonOne!.backgroundColor = Config.greenColor
        self.addSubview(buttonOne!)
    }
    
    func setupButtonTwo(target: AnyObject, action: Selector, title: String) {
        buttonTwo = UIButton(frame: CGRectMake(self.frame.width - self.frame.width * 0.47, 0, self.frame.width * 0.47, self.frame.height))
        buttonTwo!.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        buttonTwo!.setTitle(title, forState: UIControlState.Normal)
        buttonTwo!.backgroundColor = Config.redColor
        buttonTwo!.hidden = false
        self.addSubview(buttonTwo!)
    }
    
    func hideButtonTwo() {
        buttonTwo!.hidden = true
        
        // Make Button One Full Width
        buttonOne!.frame.size.width = self.frame.width
    }
    
    func showButtonTwo() {
        buttonTwo!.hidden = false
        
        // Make Button One Original Width
        buttonOne!.frame.size.width = self.frame.width * 0.47
    }
}
