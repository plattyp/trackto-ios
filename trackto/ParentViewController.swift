//
//  ViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/7/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftOverlays

class ParentViewController: UIViewController {
    
    // Services
    let loginService: LoginService = LoginService()
    
    // Additional Controllers Needed
    let notificationVC = NotificationViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func attemptLoginWithSavedCredentials(callback: (Bool) -> Void) {
        let userEmail    = loginService.retrieveEmailFromKeychain()
        let userPassword = loginService.retrievePasswordFromKeychain()
        
        loginService.loginUser(userEmail, password: userPassword) {
            success, error -> Void in
            
            callback(success)
        }
    }
    
    func renderLoginScreen() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //Hide on keyboard return
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.view.endEditing(true)
        return true;
    }
    
    //Hide on external touches outside the input
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Loading Notification
    func startLoading(labelText: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = labelText
        }
    }
    
    func stopLoading() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    // Styling For Navigation Controller
    func setupTranslucentNavigationBar() {
        // Style Navigation Bar
        self.navigationController?.navigationBar.barTintColor  = Config.lightGrayColor
        self.navigationController?.navigationBar.translucent   = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage   = UIImage()
        
        // Style Title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Config.slateColor]
    }
    
    func showErrorMessage(messageText: String) {
        let width = self.view.frame.width
        NSOperationQueue.mainQueue().addOperationWithBlock {
            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getErrorView(messageText,width: width), duration: 5)
        }
    }
    
    func showSuccessMessage(messageText: String) {
        let width = self.view.frame.width
        NSOperationQueue.mainQueue().addOperationWithBlock {
            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getSuccessView(messageText,width: width), duration: 5)
        }
    }
}

