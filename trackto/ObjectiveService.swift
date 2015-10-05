//
//  ObjectiveService.swift
//  trackto
//
//  Created by Andrew Platkin on 9/18/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class ObjectiveService: BaseRequest {
    
    let baseURL: String = Config.getProperty("apiURL")
    
    func createObjective(objective: Objective, callback:(Bool, String?) -> Void) {
        
        let createObjectiveURL = baseURL + "/objectives"

        HTTPPostJSON(createObjectiveURL, jsonObj: objective.toJSONString()) {
            response, error -> Void in
            
            if (error != nil) {
                callback(false,"Something went wrong creating your objective, try again soon")
            } else {
                callback(true,nil)
            }
        }
    }
    
    func getMyObjectives(callback: ([MyObjective], String?) -> Void) {
        let myObjectivesURL = baseURL + "/my_objectives"
    
        HTTPGetJSON(myObjectivesURL) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if (error != nil) {
                if let statusCode = response["statusCode"] as? Int {
                    // Unauthorized
                    if statusCode == 401 {
                        callback([MyObjective](), "Unauthorized")
                    } else {
                        callback([MyObjective](), error)
                    }
                } else {
                    callback([MyObjective](), error)
                }
            } else {
                var myObjectives: [MyObjective] = []
                if let data = response["data"] as? NSDictionary {
                    do {
                        if let objectivesRaw: NSData = data["objectives"]?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false) {
                            let objectives = try NSJSONSerialization.JSONObjectWithData(objectivesRaw, options: NSJSONReadingOptions.MutableContainers)
                            
                            if let objectiveArray = objectives as? [AnyObject] {
                                for objective in objectiveArray {
                                    let id   = objective["id"] as! Int
                                    let name = objective["name"] as! String
                                    
                                    let myObj = MyObjective(objName: name, objId: id, objProgress: 0.00)
                                    
                                    if let subs = objective["subobjectives"] as? [AnyObject] {
                                        for sub in subs {
                                            let subId   = sub["id"] as! Int
                                            let subName = sub["name"] as! String
                                            let lastProgressDate = sub["last_progress_date"] as! String
                                            
                                            let newSub = Subobjective(subId: subId, subName: subName, subDesc: "", lastProgressDate: lastProgressDate)
                                            myObj.addSubobjective(newSub)
                                        }
                                    }
                                    
                                    myObjectives.append(myObj)
                                }
                            }
                            callback(myObjectives, nil)
                        }
                    }
                    catch {
                        callback([MyObjective](), "Something went wrong")
                    }
                }
            }
        }
    }
    
    func getObjective(objectiveId: Int, callback: (Objective, String?) -> Void) {
        let offsetSec = NSTimeZone.localTimeZone().secondsFromGMT
        let getObjectiveURL = baseURL + "/objectives/\(objectiveId)?timezoneOffsetSeconds=\(offsetSec)"
        
        HTTPGetJSON(getObjectiveURL) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if (error != nil) {
                if let statusCode = response["statusCode"] as? Int {
                    // Unauthorized
                    if statusCode == 401 {
                        callback(Objective(), "Unauthorized")
                    } else {
                        callback(Objective(), error)
                    }
                }
            } else {
                if let data = response["data"] as? NSDictionary {
                    if let obj = data["objective"] as? NSDictionary {
                        if let objName = obj["name"] as? String {
                            if let objDesc = obj["description"] as? String {
                                let objDetail = Objective(name: objName, desc: objDesc)
                                callback(objDetail, nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
}