//
//  Objective.swift
//  trackto
//
//  Created by Andrew Platkin on 9/18/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class Objective {
    
    var objectiveId: Int
    var objectiveName: String
    var objectiveDesc: String
    var subobjectives: [Subobjective]
    
    init() {
        objectiveId   = 0
        objectiveName = ""
        objectiveDesc = ""
        subobjectives = [Subobjective]()
    }
    
    init(name: String, desc: String) {
        objectiveId   = 0
        objectiveName = name
        objectiveDesc = desc
        subobjectives = [Subobjective]()
    }
    
    init(name: String, desc: String, id: Int) {
        objectiveId   = id
        objectiveName = name
        objectiveDesc = desc
        subobjectives = [Subobjective]()
    }
    
    func addSubobjective(subobjective: Subobjective) {
        subobjectives.append(subobjective)
    }
    
    func addSubobjectives(newSubs: [Subobjective]) {
        for sub in newSubs {
            subobjectives.append(sub)
        }
    }
    
    func toJSONString() -> String {
        let objectiveDetail = "\"name\": \"\(objectiveName)\", \"description\": \"\(objectiveDesc)\", "
        var subobjectivesDetail = "\"subobjectives_attributes\":["
        
        for (index,sub) in subobjectives.enumerate() {
            subobjectivesDetail += "{" + sub.toString() + "}"
            
            // Add a trailing comma for all iterations except to the last one
            if index != (subobjectives.count - 1) {
                subobjectivesDetail += ","
            }
        }
        
        subobjectivesDetail += "]"
        
        return "{\"objective\": {" + objectiveDetail + subobjectivesDetail + "}}"
    }
}