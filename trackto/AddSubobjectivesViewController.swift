//
//  AddSubobjectivesViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/17/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class AddSubobjectivesViewController: ParentViewController {
    
    // Variables
    var viewIndex = 0
    
    //Outlets
    @IBOutlet weak var subNameInput: TextField!
    @IBOutlet weak var subDescInput: TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subNameInput.text = ""
        subDescInput.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView(subobjective: Subobjective, index: Int) {
        viewIndex = index
        subNameInput.text = subobjective.name
        subDescInput.text = subobjective.desc
    }
    
    func isValid() -> Bool{
        return (subNameInput.validatePresence() && subDescInput.validatePresence())
    }
    
    func getDescInputFrame() -> CGRect {
        return subDescInput.frame
    }
    
}
