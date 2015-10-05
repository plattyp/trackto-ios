//
//  SubobjectivesTodayViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import SwiftOverlays
import MGSwipeTableCell

class SubobjectivesTodayViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate, SubobjectiveTodayCellDelegate  {
    
    // Services
    let subobjectiveService: SubobjectiveService = SubobjectiveService()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Attributes
    var subsToday: [SubobjectiveToday] = [SubobjectiveToday]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        renderSubobjectivesToday()
    }
    
    func renderSubobjectivesToday() {
        startLoading("Loading...")
        subobjectiveService.getSubobjectivesToday() {
            subs, error -> Void in
            
            if (error != nil) {
                if error == "Unauthorized" {
                    self.attemptLoginWithSavedCredentials() {
                        success -> Void in
                        
                        if (success) {
                            self.renderSubobjectivesToday()
                        } else {
                            self.renderLoginScreen()
                        }
                    }
                } else {
                    if let errorMsg = error {
                        self.showErrorMessage(errorMsg)
                    }
                }
            } else {
                self.subsToday = subs
                self.reloadTable()
            }
            
            self.stopLoading()
        }
    }
    
    // View Setup
    func setupNavigation() {
        // Left Filter Button
        let settingsBarBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-settings"), style: .Plain, target: self, action: "settingsBtnSelected")
        settingsBarBtn.tintColor = Config.slateColor
        self.navigationItem.setLeftBarButtonItem(settingsBarBtn, animated: false)
        
        // Right Settings Button
        let triggerBarBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-rocket"), style: .Plain, target: self, action: "triggerBtnSelected")
        triggerBarBtn.tintColor = Config.slateColor
        self.navigationItem.setRightBarButtonItem(triggerBarBtn, animated: false)
        
        setupTranslucentNavigationBar()
    }
    
    func setupTableView() {
        tableView.backgroundColor  = Config.lightGrayColor
        tableView.separatorColor   = UIColor.clearColor()
        tableView.allowsSelection  = false
        tableView.contentInset     = UIEdgeInsetsMake(0, 0, 200, 0)
    }
    
    // Navigation Buttons
    
    func settingsBtnSelected() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("settingsView") 
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func triggerBtnSelected() {
        print("Trigger Selected!")
    }
    
    // Table View Methods
    func reloadTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.reloadData()
        }
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsToday.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sub = subsToday[indexPath.row]
        
        let myCell = SubobjectiveTodayTableViewCell(subobjective: sub, style: UITableViewCellStyle.Default, reuseIdentifier: "subTodayCell", rowIndexPath: indexPath, tableFrame: self.tableView.frame)
        myCell.subCellDelegate = self
        
        // Configure Buttons
        let checkmarkImg = UIImage(named: "btn-checkmark-white")
        let tintedCheckmark = checkmarkImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let addProgressButton = MGSwipeButton(title: "", icon: tintedCheckmark, backgroundColor: Config.greenColor, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.onCellChecked(sub, indexPath: indexPath)
            
            return true
        })
        addProgressButton.tintColor = Config.whiteColor
        
        myCell.leftButtons = [addProgressButton]
        myCell.leftSwipeSettings.transition = MGSwipeTransition.Drag
        myCell.leftExpansion.threshold = 3
        myCell.leftExpansion.fillOnTrigger = true
        myCell.leftExpansion.buttonIndex = 0
        
        let thumbdownImg = UIImage(named: "btn-thumbdown-white")
        let tintedThumbdown = thumbdownImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let ignoreButton = MGSwipeButton(title: "", icon: tintedThumbdown, backgroundColor: Config.silverColor, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.onCellMarkedForHide(sub, indexPath: indexPath)
            
            return true
        })
        ignoreButton.tintColor = Config.whiteColor
        
        myCell.rightButtons = [ignoreButton]
        myCell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        myCell.rightExpansion.threshold = 3
        myCell.rightExpansion.fillOnTrigger = true
        myCell.rightExpansion.buttonIndex = 0

        return myCell
    }
    
    func removeFromTableAtIndex(indexPath: NSIndexPath, animation: UITableViewRowAnimation) {
        subsToday.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation)
        reloadTable()
    }
    
    func onCellMarkedForHide(subobjectiveToday: SubobjectiveToday, indexPath: NSIndexPath) {
        removeFromTableAtIndex(indexPath, animation: UITableViewRowAnimation.Left)
    }
    
    func onCellChecked(subobjectiveToday: SubobjectiveToday, indexPath: NSIndexPath) {
        subobjectiveService.addProgressToSubobjective(subobjectiveToday) {
            success, error -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if (success) {
                    self.showSuccessMessage("Progress added to: \(subobjectiveToday.name)")
                    self.removeFromTableAtIndex(indexPath, animation: UITableViewRowAnimation.Right)
                } else {
                    if let errorMsg = error {
                        if (errorMsg != "") {
                            self.showErrorMessage(errorMsg)
                        } else {
                            self.showErrorMessage("Something went wrong")
                        }
                    }
                }
            }
        }
    }
    
}
