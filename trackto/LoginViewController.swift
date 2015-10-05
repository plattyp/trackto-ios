//
//  LoginViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import SwiftOverlays

class LoginViewController: ParentViewController {

    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBAction func onLoginPressed(sender: AnyObject) {
        let username = loginInput.text
        let password = passwordInput.text
        
        let width = self.view.bounds.width
        
        startLoading("Logging In")
        loginService.loginUser(username!, password: password!) {
            success, error -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if (success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    if let errorMsg = error {
                        if errorMsg != "" {
                            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getErrorView(errorMsg,width: width), duration: 5)
                        } else {
                            SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(self.notificationVC.getErrorView("Something went wrong", width: width), duration: 5)
                        }
                    }
                }
                
                self.stopLoading()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
