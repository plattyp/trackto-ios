//
//  MyObjectivesSectionHeader.swift
//  trackto
//
//  Created by Andrew Platkin on 9/27/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import UIKit

protocol MyObjectivesSectionHeaderDelegate {
    func onEditButtonSelected(objective: MyObjective)
}
class MyObjectivesSectionHeader: UIView {
    
    var objective: MyObjective?
    var sectionDelegate: MyObjectivesSectionHeaderDelegate?
    
    init(myObjective: MyObjective, frame: CGRect) {
        objective = myObjective
        super.init(frame: frame)
        
        setupHeader()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupHeader() {
        // Add Subheader Label
        let subheaderLabel  = UILabel(frame: CGRectMake(self.frame.width * 0.04, 0, self.frame.width * 0.85, self.frame.height))
        subheaderLabel.font = UIFont(name: "Helvetica", size: 14)
        subheaderLabel.text = objective?.name.uppercaseString
        self.addSubview(subheaderLabel)
        
        // Add Edit Button
        let editSectionButton = UIButton(frame: CGRectMake(self.frame.width * 0.88, 0, self.frame.width * 0.10, self.frame.height))
        let wrenchBtn = UIImage(named: "btn-wrench")
        let tintedWrenchBtn = wrenchBtn?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        editSectionButton.setImage(tintedWrenchBtn, forState: .Normal)
        editSectionButton.tintColor = Config.slateColor
        editSectionButton.addTarget(self, action: "editButtonSelected", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(editSectionButton)
    }
    
    func editButtonSelected() {
        sectionDelegate?.onEditButtonSelected(objective!)
    }

}
