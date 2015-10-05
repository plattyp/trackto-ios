//
//  SubobjectiveToday.swift
//  trackto
//
//  Created by Andrew Platkin on 9/12/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class SubobjectiveToday {
    var id: Int
    var name: String
    var description: String
    var objectiveId: Int
    var objectiveName: String
    var totalProgress: Int
    var streakDays: Int
    var beginStreakDate: String
    
    init() {
        id = 0
        name = ""
        description = ""
        objectiveId = 0
        objectiveName = ""
        totalProgress = 0
        streakDays = 0
        beginStreakDate = ""
    }
    
    init(subId: Int, subName: String, subDesc: String, objId: Int, objName: String, progress: Int, streakInDays: Int, streakStartDate:String) {
        id = subId
        name = subName
        description = subDesc
        objectiveId = objId
        objectiveName = objName
        totalProgress = progress
        streakDays = streakInDays
        beginStreakDate = streakStartDate
    }
    
    func streakString() -> String{
        if streakDays == 0 {
            return "None"
        } else {
            return beginStreakDate + " - Today"
        }
    }
    
    func toString() -> String {
        return "id: \(id), name: \(name), description: \(description)"
    }
}