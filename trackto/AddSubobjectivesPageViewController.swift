//
//  AddSubobjectivesPageViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/20/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import SwiftOverlays

class AddSubobjectivesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Additional Controllers Needed
    let notificationVC = NotificationViewController()
    
    // Services
    var objectiveService: ObjectiveService = ObjectiveService()
    
    // Variables
    var pageControlIndex = 0
    var objective: Objective?
    var viewControllerArray: [AddSubobjectivesViewController] = []
    
    // Controls
    var actionButtonGroup: HorizontalButtonGroup = HorizontalButtonGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Customization
        let finishBtn = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: "createObjective")
        finishBtn.tintColor = Config.greenColor
        self.navigationItem.setRightBarButtonItem(finishBtn, animated: false)
        
        let backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backToAddObjective")
        backBtn.tintColor = Config.greenColor
        self.navigationItem.setLeftBarButtonItem(backBtn, animated: false)
        
        self.title = "Add Subobjectives"
        
        // Custom Page Control Background
        self.view.backgroundColor = Config.slateColor
        
        actionButtonGroup = HorizontalButtonGroup(width: self.view.bounds.width * 0.90,height: 50, centerPoint: CGPointMake(self.view.bounds.width / 2, self.view.bounds.height * 0.85))
        actionButtonGroup.setupButtonOne(self, action: "addSubobjective", title: "Add Another")
        actionButtonGroup.setupButtonTwo(self, action: "removeSubobjective", title: "Remove")
        actionButtonGroup.hideButtonTwo()
        self.view.addSubview(actionButtonGroup)
        
        // Set up Page View Controller
        self.delegate   = self
        self.dataSource = self
        
        // Add the first Subobjective View
        addSubobjective()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addSubobjective() {
        // First Subobjective
        if viewControllerArray.count == 0 {
            // Create a blank Subobjective View
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addSubobjectivesView") as! AddSubobjectivesViewController
            let newSub = Subobjective(subName: "", subDesc: "")
            
            var newIndex = 0
            
            if viewControllerArray.count > 0 {
                newIndex = viewControllerArray.count
            }
            
            viewControllerArray.append(vc)
            
            // Forward Along To The New Subobjective
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.setViewControllers([self.viewControllerArray[self.viewControllerArray.count - 1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                vc.setupView(newSub, index: newIndex)
            }
            
            pageControlIndex = newIndex
        // Additional Subobjectives
        } else {
            let currentVC = viewControllerArray[pageControlIndex] as AddSubobjectivesViewController
            if currentVC.isValid() {
                // Create a blank Subobjective View
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addSubobjectivesView") as! AddSubobjectivesViewController
                let newSub = Subobjective(subName: "", subDesc: "")
                
                var newIndex = 0
                
                if viewControllerArray.count > 0 {
                    newIndex = viewControllerArray.count
                }
                
                viewControllerArray.append(vc)
                
                // Forward Along To The New Subobjective
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.setViewControllers([self.viewControllerArray[newIndex]], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: {
                        _ in
                        
                        // Allow you to remove
                        self.actionButtonGroup.showButtonTwo()
                        self.updatePageControlIndicatorIndexDisplayed(newIndex)
                        self.updateViewIndexes()
                        
                    })
                    
                    vc.setupView(newSub, index: newIndex)
                }
            }
        }
    }
    
    func removeSubobjective() {
        // Forward Along To The Last Subobjective
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.setViewControllers([self.viewControllerArray[0]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion:{
                _ in
                
                let indexForRemoval = self.pageControlIndex
                self.viewControllerArray.removeAtIndex(indexForRemoval)
                
                self.updatePageControlIndicatorCount()
                
                self.updatePageControlIndicatorIndexDisplayed(0)
                
                // Since it routes to 0, hide the button
                self.actionButtonGroup.hideButtonTwo()
                
                self.updateViewIndexes()
            })
        }
    }
    
    func viewControllerAtIndex(index: Int) -> AddSubobjectivesViewController! {
        if (viewControllerArray.count - 1) >= index {
            return viewControllerArray[index]
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let subobjectiveViewController = viewController as! AddSubobjectivesViewController

        if subobjectiveViewController.viewIndex > 0 {
            let newIndex = subobjectiveViewController.viewIndex - 1
            return viewControllerAtIndex(newIndex)
        }
        
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let subobjectiveViewController = viewController as! AddSubobjectivesViewController
        let newIndex = subobjectiveViewController.viewIndex + 1
        
        if newIndex < viewControllerArray.count {
            return viewControllerAtIndex(newIndex)
        }
        
        return nil
        
    }
    
    func backToAddObjective() {
        let alert: UIAlertController = UIAlertController(title: "Are you sure?", message: "By going back, you will lose all Subobjective progress", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            _ in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let goBackOption = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            _ in
        
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        })
        
        alert.addAction(goBackOption)
        alert.addAction(cancelOption)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageControlIndex
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllerArray.count
    }
    
    // This is a workaround method because the existing way of updating view presentation count is not working with remove
    func updatePageControlIndicatorCount() {
        let pageControl = getPageControl()
        
        pageControl.numberOfPages = viewControllerArray.count
    }
    
    // This is a workaround method because the existing way of updating view presentation count is not working with remove
    func updatePageControlIndicatorIndexDisplayed(newIndex: Int) {
        let pageControl = getPageControl()
        
        pageControl.currentPage = newIndex
        pageControlIndex = newIndex
    }
    
    func getPageControl() -> UIPageControl {
        let subviews: Array = self.view.subviews
        var pageControl: UIPageControl! = nil
        
        for (var i = 0; i < subviews.count; i++) {
            if (subviews[i] is UIPageControl) {
                pageControl = subviews[i] as! UIPageControl
                break
            }
        }
        
        return pageControl
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let subVCArray = pendingViewControllers as! [AddSubobjectivesViewController]
        
        if subVCArray[0].viewIndex == 0 {
            actionButtonGroup.hideButtonTwo()
        } else {
            actionButtonGroup.showButtonTwo()
        }
        
        // This index is important for action buttons
        pageControlIndex = subVCArray[0].viewIndex
    }
    
    func moveToSpecificViewIndex(index: Int) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.setViewControllers([self.viewControllerArray[index]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
            // Allow you to remove
            if index == 0 {
                self.actionButtonGroup.hideButtonTwo()
            } else {
                self.actionButtonGroup.showButtonTwo()
            }
            
            self.updatePageControlIndicatorIndexDisplayed(index)
        }
    }
    
    func updateViewIndexes() {
        var newArray: [AddSubobjectivesViewController] = []
        for (index, subView): (Int, AddSubobjectivesViewController) in viewControllerArray.enumerate() {
            subView.viewIndex = index
            newArray.append(subView)
        }
        viewControllerArray = newArray
    }
    
    func createObjective() {
        var success = true
        var subobjectives: [Subobjective] = []
        for (index, subView): (Int, AddSubobjectivesViewController) in viewControllerArray.enumerate() {
            if (subView.subNameInput.validatePresence() && subView.subDescInput.validatePresence()) {
                let sub = Subobjective(subName: subView.subNameInput.text!, subDesc: subView.subDescInput.text)
                subobjectives.append(sub)
            } else {
                self.moveToSpecificViewIndex(index)
                success = false
                break
            }
        }
        
        if (success) {
            objective?.addSubobjectives(subobjectives)
            
            let width = self.view.bounds.width
            
            objectiveService.createObjective(objective!) {
                success, error -> Void in
                
                if (success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getSuccessView("Objective created successfully", width: width), duration: 5)
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        if let errorMsg: String = error {
                            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getErrorView(errorMsg, width: width), duration: 5)
                        }
                    }
                }
            }
        }
    }

}
