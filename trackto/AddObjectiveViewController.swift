//
//  AddObjectiveViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/14/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class AddObjectiveViewController: ParentViewController {

    var objective: Objective?
    
    @IBOutlet weak var objectiveNameInput: TextField!
    @IBOutlet weak var objectiveDescInput: TextView!
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Customization
        let nextBtn   = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "goToAddSubobjectives")
        nextBtn.tintColor = Config.greenColor
        self.navigationItem.setRightBarButtonItem(nextBtn, animated: false)
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "closeView:")
        cancelBtn.tintColor = Config.slateColor
        self.navigationItem.setLeftBarButtonItem(cancelBtn, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToAddSubobjectives() {
        if (objectiveNameInput.validatePresence() && objectiveDescInput.validatePresence()) {
            objective = Objective(name: objectiveNameInput.text!, desc: objectiveDescInput.text)
            self.performSegueWithIdentifier("goToAddSubobjectives", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToAddSubobjectives" {
            let vc: AddSubobjectivesPageViewController = segue.destinationViewController as! AddSubobjectivesPageViewController
            vc.objective = objective
        }
    }
}
