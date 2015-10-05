//
//  HorizontalButtonGroupFlex.swift
//  trackto
//
//  Created by Andrew Platkin on 9/26/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class HorizontalButtonGroupWithIcons: UIView {

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
    
    func setupButtonOne(target: AnyObject, action: Selector, icon: UIImage) {
        buttonOne = UIButton(frame: CGRectMake(self.frame.width * 0.02, 0, self.frame.width * 0.43, self.frame.height))
        buttonOne!.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        buttonOne!.setImage(icon, forState: .Normal)
        buttonOne!.imageView?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        buttonOne!.backgroundColor = Config.silverColor
        buttonOne!.layer.cornerRadius = 5.0
        self.addSubview(buttonOne!)
    }
    
    func setupButtonTwo(target: AnyObject, action: Selector, icon: UIImage) {
        buttonTwo = UIButton(frame: CGRectMake(buttonOne!.frame.maxX + self.frame.width * 0.05, 0, buttonOne!.frame.width, self.frame.height))
        buttonTwo!.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        buttonTwo!.setImage(icon, forState: .Normal)
        buttonTwo!.imageView?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        buttonTwo!.backgroundColor = Config.greenColor
        buttonTwo!.layer.cornerRadius = 5.0
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
