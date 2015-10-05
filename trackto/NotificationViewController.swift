//
//  NotificationViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/20/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    
    @IBOutlet var notificationView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSuccessView(messageText: String, width: CGFloat) -> UIView {
        NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
        
        // Customize View
        notificationView.frame.size.width = width;
        notificationView.backgroundColor  = Config.greenColor
        messageLabel.textColor = Config.whiteColor
        messageLabel.text      = messageText
        
        return notificationView
    }
    
    func getErrorView(messageText: String, width: CGFloat) -> UIView {
        NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
        
        // Customize View
        notificationView.frame.size.width = width;
        notificationView.backgroundColor  = Config.redColor
        messageLabel.text = messageText
        
        return notificationView
    }

}
