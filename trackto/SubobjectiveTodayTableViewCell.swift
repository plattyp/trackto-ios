//
//  SubobjectiveViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/13/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit
import Foundation
import MGSwipeTableCell

protocol SubobjectiveTodayCellDelegate {
    func onCellMarkedForHide(subobjectiveToday: SubobjectiveToday, indexPath: NSIndexPath)
    func onCellChecked(subobjectiveToday: SubobjectiveToday, indexPath: NSIndexPath)
}
class SubobjectiveTodayTableViewCell: MGSwipeTableCell, SubobjectiveTodayCardDelegate {
    
    // Variables
    var subCellDelegate: SubobjectiveTodayCellDelegate?
    var subobjectiveToday: SubobjectiveToday
    var indexPath: NSIndexPath
    var tableFrame: CGRect
    
    // Outlets
    var card = SubobjectiveTodayCard()
    
    init(subobjective: SubobjectiveToday, style: UITableViewCellStyle, reuseIdentifier: String!, rowIndexPath: NSIndexPath, tableFrame: CGRect) {
        self.subobjectiveToday = subobjective
        self.indexPath = rowIndexPath
        self.tableFrame = tableFrame
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        self.subobjectiveToday = SubobjectiveToday()
        self.indexPath = NSIndexPath()
        self.tableFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 210)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        self.subobjectiveToday = SubobjectiveToday()
        self.indexPath = NSIndexPath()
        self.tableFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 210)
        super.init(coder: aDecoder)
    }
    
    func setupView() {        
        // Colors
        self.backgroundColor = Config.lightGrayColor
        
        // Set Cell Height
        let cellHeight:CGFloat = 210.0
        let cellWidth = tableFrame.width
        self.bounds   = CGRectMake(0, 0, cellWidth, cellHeight)
        
        card = SubobjectiveTodayCard(frame: self.bounds, sub: subobjectiveToday)
        card.subTodayDelegate = self
        self.contentView.addSubview(card)
    }
    
    func onCardChecked(subobjectiveToday: SubobjectiveToday) {
        subCellDelegate?.onCellChecked(subobjectiveToday, indexPath: indexPath)
    }
    
    func onCardMarkedForHide(subobjectiveToday: SubobjectiveToday) {
        subCellDelegate?.onCellMarkedForHide(subobjectiveToday, indexPath: indexPath)
    }
}
