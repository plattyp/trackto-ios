//
//  MainTabBarController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/13/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    let addObjectiveTag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Bar Color
        UITabBar.appearance().barTintColor = Config.slateColor
        
        // Set Selector Image
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Add Subview to cover Add button
        let countOfItemsInTabBar = self.tabBar.items != nil ? self.tabBar.items!.count : 3
        let itemWidth = self.tabBar.frame.width / CGFloat(countOfItemsInTabBar)
        let bgView = UIView(frame: CGRectMake(itemWidth * CGFloat(self.addObjectiveTag), 0, itemWidth, self.tabBar.frame.height))
        bgView.backgroundColor = Config.grayColor
        self.tabBar.insertSubview(bgView, atIndex: 0)
        
        // Change Font Color of Add Button
        if let items = self.tabBar.items as [UITabBarItem]? {
            for tab in items {
                if tab.tag == self.addObjectiveTag {
                    tab.setTitleTextAttributes([NSForegroundColorAttributeName:Config.slateColor], forState: UIControlState.Normal)
                    tab.image = tab.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Prevent default action to show the "Add Objective" view
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController.tabBarItem.tag == self.addObjectiveTag) {
            return false
        }
        return true
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == self.addObjectiveTag) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("addObjectiveNavController") 
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

}
