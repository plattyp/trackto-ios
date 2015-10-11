//
//  SubobjectiveDetailViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 10/6/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class SubobjectiveDetailViewController: ParentViewController {
    
    // Attributes
    var subobjective: Subobjective?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Navigation Buttons
        let closeBtn = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "closeView")
        closeBtn.tintColor = Config.slateColor
        self.navigationItem.setLeftBarButtonItem(closeBtn, animated: false)
        
        // Set Title
        if let sub = subobjective {
            self.title = sub.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
