//
//  EditObjectiveViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/28/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class EditObjectiveViewController: ParentViewController {
    
    // Services
    let objectiveService: ObjectiveService = ObjectiveService()
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Attributes
    var objectiveId: Int?
    var nameTextField = TextField()
    var descTextView = TextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Customization
        let nextBtn   = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.Plain, target: self, action: "updateObjective")
        nextBtn.tintColor = Config.greenColor
        self.navigationItem.setRightBarButtonItem(nextBtn, animated: false)
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "closeView")
        cancelBtn.tintColor = Config.slateColor
        self.navigationItem.setLeftBarButtonItem(cancelBtn, animated: false)
        
        // Setup Scrollview
        scrollView.frame.size.width = self.view.frame.width
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 800)
        
        //Render Other Fields & Data
        renderFieldsOnScrollView()
        loadObjective()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateObjective() {
        print("Update Objective Pressed!")
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func renderFieldsOnScrollView() {
        /* Name Textfield */
        
        // Setup Field
        let textWidth = scrollView.frame.width * 0.80
        nameTextField = TextField(frame: CGRectMake(scrollView.frame.width * 0.05,0, scrollView.frame.width * 0.80, 30))
        nameTextField.font = nameTextField.font?.fontWithSize(14.0)
        scrollView.addSubview(nameTextField)
        
        // Setup Constraints
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        let topGuide = NSLayoutConstraint(item: nameTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 30)
        let leadingMarginTextWidth = NSLayoutConstraint(item: nameTextField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        let trailingMarginTextWidth = NSLayoutConstraint(item: nameTextField, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: nameTextField, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        NSLayoutConstraint.activateConstraints([topGuide, leadingMarginTextWidth, trailingMarginTextWidth, heightConstraint])
        
        /* Name Label */
        
        // Setup Label
        let nameLabel = UILabel(frame: CGRectMake(scrollView.frame.width * 0.05, 0, scrollView.frame.width * 0.80, 30))
        nameLabel.text = "Name"
        nameLabel.tintColor = UIColor.blackColor()
        scrollView.addSubview(nameLabel)
        
        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let verticalSpaceNameLabel = NSLayoutConstraint(item: nameTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: nameLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        let leadingMarginNameLabel = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([verticalSpaceNameLabel,leadingMarginNameLabel])
        
        /* Desc Label */
        
        // Setup Desc Label
        let descLabel = UILabel(frame: CGRectMake(nameLabel.frame.origin.x, nameTextField.frame.maxY + nameLabel.frame.height * 0.2, nameLabel.frame.width, 30))
        descLabel.text = "Description"
        nameLabel.tintColor = UIColor.blackColor()
        scrollView.addSubview(descLabel)
        
        // Setup Constraints
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        let verticalSpaceDescLabel = NSLayoutConstraint(item: descLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: nameTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 30)
        let leadingMarginDescLabel = NSLayoutConstraint(item: descLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        NSLayoutConstraint.activateConstraints([verticalSpaceDescLabel, leadingMarginDescLabel])
        
        
        /* Desc Textview */
        
        // Setup Desc Textview
        descTextView = TextView(frame: CGRectMake(nameLabel.frame.origin.x, descLabel.frame.maxY + nameLabel.frame.height * 0.2, textWidth, 90))
        descTextView.font = nameTextField.font
        scrollView.addSubview(descTextView)
        
        // Setup Constraints
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        let verticalSpaceDescTextView = NSLayoutConstraint(item: descTextView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: descLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        let leadingMarginDescTextView = NSLayoutConstraint(item: descTextView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        let trailingMarginDescTextView = NSLayoutConstraint(item: descTextView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        let heightConstraintDescTextView = NSLayoutConstraint(item: descTextView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90)
        NSLayoutConstraint.activateConstraints([verticalSpaceDescTextView, leadingMarginDescTextView, trailingMarginDescTextView, heightConstraintDescTextView])
        
        /* Delete Button */
        
        // Setup Delete Button
        let deleteObjPosition = descTextView.frame.origin.y + descTextView.frame.height * 4
        let deleteObjButton = SlateButton(frame: CGRectMake(0, deleteObjPosition, descTextView.frame.width, 50))
        deleteObjButton.center = CGPointMake(scrollView.frame.width / 2, deleteObjButton.frame.origin.y)
        deleteObjButton.setTitle("Delete Objective", forState: UIControlState.Normal)
        deleteObjButton.addTarget(self, action: "deleteObjective", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(deleteObjButton)
        
        // Setup Constraints
        deleteObjButton.translatesAutoresizingMaskIntoConstraints = false
        let leadingMarginDeleteObjButton = NSLayoutConstraint(item: deleteObjButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        let trailingMarginDeleteObjButton = NSLayoutConstraint(item: deleteObjButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        let verticalSpaceDeleteObjButton = NSLayoutConstraint(item: deleteObjButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: descTextView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 200)
        let heightConstraintDeleteObjButton = NSLayoutConstraint(item: deleteObjButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activateConstraints([leadingMarginDeleteObjButton,trailingMarginDeleteObjButton, verticalSpaceDeleteObjButton, heightConstraintDeleteObjButton])
    }
    
    func loadObjective() {
        if let id = objectiveId {
            self.startLoading("Loading Objective...")
            objectiveService.getObjective(id) {
                objective, error -> Void in
                
                if (error != nil) {
                    if error == "Unauthorized" {
                        self.attemptLoginWithSavedCredentials() {
                            success -> Void in
                            
                            if (success) {
                                self.loadObjective()
                            } else {
                                self.renderLoginScreen()
                            }
                        }
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.nameTextField.text = objective.objectiveName
                        self.descTextView.text = objective.objectiveDesc
                    }
                }
                self.stopLoading()
            }
        }
    }
    
    func deleteObjective() {
        print("Delete Objective Pressed!")
    }

}
