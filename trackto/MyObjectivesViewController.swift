//
//  MyObjectivesViewController.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import UIKit

class MyObjectivesViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, MyObjectivesSectionHeaderDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // Services
    var objectiveService: ObjectiveService = ObjectiveService()
    
    // Attributes
    var objectives: [MyObjective] = [MyObjective]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupView()
        setupNavigation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func applicationDidBecomeActive() {
        loadData()
    }
    
    func loadData() {
        objectiveService.getMyObjectives() {
            objs, error -> Void in
            
            if (error != nil) {
                if error == "Unauthorized" {
                    self.attemptLoginWithSavedCredentials() {
                        success -> Void in
                        
                        if (success) {
                            self.loadData()
                        } else {
                            self.renderLoginScreen()
                        }
                    }
                } else {
                    if let errorMsg = error {
                        self.showErrorMessage(errorMsg)
                    }
                }
            } else {
                self.objectives = objs
                self.reloadTable()
            }
        }
    }
    
    func setupTable() {
        self.tableView.backgroundColor = Config.lightGrayColor
    }
    
    func setupView() {
        self.view.backgroundColor = Config.lightGrayColor
    }
    
    func setupNavigation() {
        setupTranslucentNavigationBar()
    }
    
    // Table View Methods
    func reloadTable() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectives.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectives[section].subobjectives.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectives[section].name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sub = objectives[indexPath.section].subobjectives[indexPath.row]
        
        let myCell = MyObjectiveTableViewCell(sub: sub, style: UITableViewCellStyle.Default, reuseIdentifier: "myObjectiveCell", rowIndexPath: indexPath)
        
        return myCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let obj = objectives[section]
        let sectionHeader = MyObjectivesSectionHeader(myObjective: obj, frame: CGRectMake(0, 0, self.view.frame.width, 30))
        sectionHeader.sectionDelegate = self
        return sectionHeader
    }
    
    func onEditButtonSelected(objective: MyObjective) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("editObjectiveNav") as! EditObjectiveNavigationController
        (vc.viewControllers[0] as! EditObjectiveViewController).objectiveId = objective.id
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
