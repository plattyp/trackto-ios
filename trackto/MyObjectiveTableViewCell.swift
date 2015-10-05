//
//  MyObjectiveTableViewCell.swift
//  trackto
//
//  Created by Andrew Platkin on 9/26/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import Foundation

class MyObjectiveTableViewCell: UITableViewCell {
    
    // Variables
    var subobjective: Subobjective
    var indexPath: NSIndexPath

    init(sub: Subobjective, style: UITableViewCellStyle, reuseIdentifier: String!, rowIndexPath: NSIndexPath) {
        subobjective = sub
        indexPath = rowIndexPath
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        subobjective = Subobjective()
        indexPath = NSIndexPath()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        subobjective = Subobjective()
        indexPath = NSIndexPath()
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Add Subobjective Label
        let subNameLabel = UILabel(frame: CGRectMake(self.frame.width * 0.05, self.frame.height * 0.25, self.frame.width, self.frame.height * 0.45))
        subNameLabel.font = subNameLabel.font.fontWithSize(18)
        subNameLabel.text = subobjective.name
        self.addSubview(subNameLabel)
        
        // Add Last Progress On Subheader
        let lastProgressSubheader = UILabel(frame: CGRectMake(subNameLabel.frame.origin.x, subNameLabel.frame.maxY * 1.20, self.frame.width, self.frame.height * 0.33))
        lastProgressSubheader.font = lastProgressSubheader.font.fontWithSize(12)
        lastProgressSubheader.text = "Last Progress On: \(subobjective.lastProgressOnDate())"
        self.addSubview(lastProgressSubheader)
    }
}
