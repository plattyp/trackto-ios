//
//  Subobjective.swift
//  trackto
//
//  Created by Andrew Platkin on 9/18/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class Subobjective {
    
    var id: Int
    var name: String
    var desc: String
    var lastProgressOn: String
    
    init() {
        id = 0
        name = ""
        desc = ""
        lastProgressOn = "Never"
    }
    
    init(subName: String, subDesc: String) {
        id = 0
        name = subName
        desc = subDesc
        lastProgressOn = "Never"
    }
    
    init(subId: Int, subName: String, subDesc: String, lastProgressDate: String) {
        id = subId
        name = subName
        desc = subDesc
        lastProgressOn = lastProgressDate
    }
    
    func toString() -> String {
        return "\"name\": \"\(name)\", \"description\": \"\(desc)\""
    }
    
    func lastProgressOnDate() -> String {
        var newDateString = lastProgressOn
        if lastProgressOn != "Never" {
            // For Parsing
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let parsedDate: NSDate = dateFormatter.dateFromString(lastProgressOn)!
            
            // For Formatting
            dateFormatter.dateFormat = "yyyy-MM-dd"
            newDateString = "\(dateFormatter.stringFromDate(parsedDate))"
        }
        return newDateString
    }
}