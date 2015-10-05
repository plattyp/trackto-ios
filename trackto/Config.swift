//
//  Config.swift
//  trackto
//
//  Created by Andrew Platkin on 9/12/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation
import UIKit

class Config {
    
    // Constants
    class var whiteColor: UIColor {
        return UIColor.whiteColor()
    }
    
    class var slateColor: UIColor {
        return UIColor(red: 62/255, green: 44/255, blue: 66/255, alpha: 1)
    }
    
    class var greenColor: UIColor {
        return UIColor(red: 26/255, green: 179/255, blue: 148/255, alpha: 1)
    }
    
    class var grayColor: UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 244/255, alpha: 1)
    }
    
    class var goldColor: UIColor {
        return UIColor(red: 164/255, green: 108/255, blue: 65/255, alpha: 1)
    }
    
    class var silverColor: UIColor {
        return UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 1)
    }
    
    class var lightGrayColor: UIColor {
        return UIColor(red: 244/255, green: 246/255, blue: 250/255, alpha: 1)
    }
    
    class var redColor: UIColor {
        return UIColor(red: 237/255, green: 85/255, blue: 101/255, alpha: 1)
    }
    
    class var lavenderColor : UIColor {
        return UIColor(red: 231/255, green: 234/255, blue: 236/255, alpha: 1)
    }

    class func getProperty(name: String) -> String {
        var myDict = NSDictionary()
        
        if let path = NSBundle.mainBundle().pathForResource("properties", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)!
        }
        
        let envDict = myDict.objectForKey("development")! as! NSDictionary
        return envDict.objectForKey(name)! as! String
    }
}