//
//  MyObjective.swift
//  trackto
//
//  Created by Andrew Platkin on 9/26/15.
//  Copyright © 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class MyObjective {
    
    var id: Int
    var name: String
    var progress: Float
    var subobjectives: [Subobjective]
    
    init() {
        name = ""
        id = 0
        progress = 0.0
        subobjectives = []
    }
    
    init(objName: String, objId: Int, objProgress: Float) {
        name = objName
        id = objId
        progress = objProgress
        subobjectives = []
    }
    
    func addSubobjective(subobjective: Subobjective) {
        subobjectives.append(subobjective)
    }
    
    func numOfSubs() -> Int {
        return subobjectives.count
    }
    
}