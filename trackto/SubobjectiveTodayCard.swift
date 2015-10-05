import Foundation
import UIKit

protocol SubobjectiveTodayCardDelegate {
    func onCardMarkedForHide(subobjectiveToday: SubobjectiveToday)
    func onCardChecked(subobjectiveToday: SubobjectiveToday)
}
class SubobjectiveTodayCard: UIView {
    
    // Variables
    var subTodayDelegate: SubobjectiveTodayCardDelegate?
    var subobjectiveToday: SubobjectiveToday
    
    // Outlets
    var actionButtons = HorizontalButtonGroupWithIcons()
    
    required init?(coder aDecoder: NSCoder) {
        self.subobjectiveToday = SubobjectiveToday()
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, sub: SubobjectiveToday) {
        self.subobjectiveToday = sub
        super.init(frame: frame)
        
        let cellWidth  = frame.size.width
        let cellHeight = frame.size.height
        
        // Create View Container
        let containerView = UIView(frame: CGRectMake(0, 0, cellWidth * 0.90, cellHeight * 0.85))
        containerView.backgroundColor = Config.whiteColor
        containerView.center = CGPointMake(cellWidth/2, cellHeight/2)
        self.addSubview(containerView)
        
        // Add Header Label To View
        let nameLabel = UILabel(frame: CGRectMake(containerView.frame.origin.x * 1.35, containerView.frame.origin.y, cellWidth * 0.75, cellHeight * 0.25))
        nameLabel.font = UIFont.boldSystemFontOfSize(16.0)
        nameLabel.text = subobjectiveToday.name
        self.addSubview(nameLabel)
        
        // Add Line Seperator
        let bottomHeaderPosition = nameLabel.frame.origin.y + nameLabel.frame.size.height
        let headerLine = UIView(frame: CGRectMake(containerView.frame.origin.x, bottomHeaderPosition, containerView.frame.size.width, 1))
        headerLine.backgroundColor = Config.lavenderColor
        self.addSubview(headerLine)
        
        // Setup Action Buttons Right Side Of Label
        actionButtons = HorizontalButtonGroupWithIcons(width: containerView.frame.width / 4, height: cellHeight * 0.15, centerPoint: CGPointMake((containerView.frame.maxX - (containerView.frame.width / 4) + (containerView.frame.width / 8)), (((nameLabel.frame.maxY - nameLabel.frame.minY) / 2) + nameLabel.frame.minY)))
        actionButtons.setupButtonOne(self, action: "hideCard", icon: UIImage(named: "btn-thumbdown-white")!)
        actionButtons.setupButtonTwo(self, action: "cardChecked", icon: UIImage(named: "btn-checkmark-white")!)
        self.addSubview(actionButtons)
        
        // Add Description Text To View
        let descText    = UITextView(frame: CGRectMake(containerView.frame.origin.x * 1.35, headerLine.frame.origin.y * 1.2, containerView.frame.size.width * 0.98, containerView.frame.size.height * 0.40))
        descText.center = CGPointMake(cellWidth / 2, (containerView.frame.size.height + (nameLabel.frame.size.height * 0.7)) / 2)
        descText.text   = subobjectiveToday.description
        descText.backgroundColor = Config.whiteColor
        descText.editable = false
        descText.selectable = false
        self.addSubview(descText)
        
        // Add Bottom Seperator Line
        let descBottomLinePosition = descText.frame.origin.y + descText.frame.size.height
        let bottomLine = UIView(frame: CGRectMake(containerView.frame.origin.x, descBottomLinePosition, containerView.frame.size.width, 1))
        bottomLine.backgroundColor = Config.lavenderColor
        self.addSubview(bottomLine)
        
        // Add Bottom Vertical Section Divider
        let bottomOfContainerY = containerView.frame.maxY - descBottomLinePosition
        let bottomDivider = UIView(frame: CGRectMake(cellWidth / 2, descBottomLinePosition, 1.0, bottomOfContainerY))
        bottomDivider.backgroundColor = Config.lavenderColor
        self.addSubview(bottomDivider)
        
        // Add Total Progress Subheader
        let totalProgressText = UILabel(frame: CGRectMake(containerView.frame.origin.x * 1.35, bottomLine.frame.origin.y, bottomLine.frame.size.width / 2, bottomDivider.frame.size.height * 0.4))
        totalProgressText.font = totalProgressText.font.fontWithSize(12)
        totalProgressText.text = "Total Progress"
        self.addSubview(totalProgressText)
        
        // Add Total Progress Text
        let totalProgress = UILabel(frame: CGRectMake(totalProgressText.frame.origin.x, totalProgressText.frame.origin.y * 1.12, totalProgressText.frame.size.width, bottomDivider.frame.size.height * 0.5))
        totalProgress.font = UIFont.boldSystemFontOfSize(16.0)
        totalProgress.text = "\(subobjectiveToday.totalProgress)"
        self.addSubview(totalProgress)
        
        // Add Streak Subheader
        let streakSubheaderText = UILabel(frame: CGRectMake((cellWidth / 2) * 1.04, bottomLine.frame.origin.y, bottomLine.frame.size.width / 2, bottomDivider.frame.size.height * 0.4))
        streakSubheaderText.font = totalProgressText.font.fontWithSize(12)
        streakSubheaderText.text = "Current Streak"
        self.addSubview(streakSubheaderText)
        
        // Add Streak Text
        let streakText = UILabel(frame: CGRectMake(streakSubheaderText.frame.origin.x, streakSubheaderText.frame.origin.y * 1.12, streakSubheaderText.frame.size.width, bottomDivider.frame.size.height * 0.5))
        streakText.font = UIFont.boldSystemFontOfSize(16.0)
        streakText.text = subobjectiveToday.streakString()
        self.addSubview(streakText)
        
        // Add Outer Border
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = Config.lavenderColor.CGColor
    }
    
    override init(frame: CGRect) {
        self.subobjectiveToday = SubobjectiveToday()
        super.init(frame: frame)
    }
    
    func hideCard() {
        subTodayDelegate?.onCardMarkedForHide(subobjectiveToday)
    }
    
    func cardChecked() {
        subTodayDelegate?.onCardChecked(subobjectiveToday)
    }
}