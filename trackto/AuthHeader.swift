//
//  AuthHeaders.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation

class AuthHeader {
    var accessToken: String
    var client: String
    var expiry: String
    var tokenType: String
    var uid: String
    
    init() {
        accessToken = ""
        client      = ""
        expiry      = ""
        tokenType   = "Bearer"
        uid         = ""
    }
    
    init(token: String, clientSrc: String, expiryNum: String, userId: String) {
        accessToken = token
        client      = clientSrc
        expiry      = expiryNum
        tokenType   = "Bearer"
        uid         = userId
    }
    
    func toString() -> String {
        return "accessToken: " + accessToken + ", client: " + client + ", expiry: \(expiry) , tokenType: " + tokenType + ", uid: " + uid
    }
}