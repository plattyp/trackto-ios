//
//  NotificationView.swift
//  trackto
//
//  Created by Andrew Platkin on 9/20/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    @IBOutlet var notificationView: UIView!
    
    init() {
        var frame = CGRectMake(0, 0, 100, 100)
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
        notificationView.frame.size.width = self.window!.bounds.width
    }
    
    func getView() -> UIView {
        return notificationView
    }

}
