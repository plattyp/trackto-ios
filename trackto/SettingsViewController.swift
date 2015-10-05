//
//  SettingsViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/21/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import SwiftOverlays

class SettingsViewController: ParentViewController {

    @IBOutlet weak var logoutButton: SlateButton!
    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {
        let width = self.view.bounds.width
        startLoading("Logging out")
        loginService.logoutUser() {
            success, error -> Void in
            
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getSuccessView("Successfully logged out", width: width), duration: 5)
                }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getErrorView("Something went wrong", width: width), duration: 5)
                }
            }
            
            self.stopLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Close Button
        let closeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-ex"), style: UIBarButtonItemStyle.Plain, target: self, action: "closeView")
        closeButton.tintColor = Config.slateColor
        self.navigationItem.setLeftBarButtonItem(closeButton, animated: false)
        
        // Set Title
        self.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
