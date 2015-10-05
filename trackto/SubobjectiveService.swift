//
//  SubobjectiveService.swift
//  trackto
//
//  Created by Andrew Platkin on 9/12/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class SubobjectiveService: BaseRequest {
    
    let baseURL: String = Config.getProperty("apiURL")
    
    func getSubobjectivesToday(callback:([SubobjectiveToday], String?) -> Void) {
        let offsetSec = NSTimeZone.localTimeZone().secondsFromGMT
        
        let todayUrl = baseURL + "/subobjectives_today_enhanced?offsetSeconds=\(offsetSec)"
        
        HTTPGetJSON(todayUrl) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                if let statusCode = response["statusCode"] as? Int {
                    // Unauthorized
                    if statusCode == 401 {
                        callback([SubobjectiveToday](), "Unauthorized")
                    } else {
                        callback([SubobjectiveToday](), error)
                    }
                } else {
                    callback([SubobjectiveToday](), error)
                }
            } else {
                if let data = response["data"] as? NSDictionary {
                    if let subs = data["subobjectives"] as? [AnyObject] {
                        var convertedSubs = [SubobjectiveToday]()
                        for sub in subs {
                            if let id = sub["id"] as? Int {
                                if let name = sub["name"] as? String {
                                    if let desc = sub["description"] as? String {
                                        if let objId = sub["objective_id"] as? String {
                                            let convertedObjId: Int  = Int(objId)!
                                            if let objName = sub["objective_name"] as? String {
                                                if let progress = sub["sub_progress"] as? Int {
                                                    if let streakInDays = sub["streak"] as? Int {
                                                        if let beginStreak = sub["streak_begin_date"] as? String {
                                                            let subToday = SubobjectiveToday(
                                                                subId: id,
                                                                subName: name,
                                                                subDesc: desc,
                                                                objId: convertedObjId,
                                                                objName: objName,
                                                                progress: progress,
                                                                streakInDays: streakInDays,
                                                                streakStartDate: beginStreak
                                                            )
                                                            convertedSubs.append(subToday)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        callback(convertedSubs,nil)
                    }
                }
            }
        }
    }
    
    func addProgressToSubobjective(subobjectiveToday: SubobjectiveToday, callback:(Bool, String?) -> Void) {
        let addProgressURL = baseURL + "/subobjectives/\(subobjectiveToday.id)/add_progress"
        
        let addtionalParams = ""
        
        HTTPPostJSON(addProgressURL, jsonObj: addtionalParams) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if (error != nil) {
                if let statusCode = response["statusCode"] as? Int {
                    // Unauthorized
                    if statusCode == 401 {
                        callback(false, "Unauthorized")
                    } else {
                        callback(false, error)
                    }
                } else {
                    callback(false, error)
                }
            } else {
                callback(true, nil)
            }
            
        }
    }
}