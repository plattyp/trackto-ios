//
//  LoginService.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation
import KeychainAccess

class LoginService: BaseRequest {
    
    let baseURL: String = Config.getProperty("apiURL") + "/auth"
    
    func loginUser(email: String, password: String, callback: (Bool, String?) -> Void) {
        let loginURL: String = baseURL + "/sign_in"
        let jsonObj: AnyObject = "{\"email\": \"\(email)\", \"password\": \"\(password)\"}"
        
        print("Logging In!")
        wipeOutExistingAuthHeadersFromKeychain()
        
        HTTPPostJSON(loginURL, jsonObj: jsonObj) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                callback(false,error)
            } else {
                let errorMsg = ""
                var hasErrors = false
                if let data = response["data"] as? NSDictionary {
                    if let errors = data["errors"] as? [String] {
                        hasErrors = true
                        if errors.count > 0 {
                            errorMsg == errors[0]
                            callback(false, errors[0])
                        }
                    }
                }
                if (!hasErrors) {
                    self.saveEmailAndPasswordInKeychain(email, password: password)
                    callback(true,nil)
                }
            }
        }
    }
    
    func logoutUser(callback: (Bool, String?) -> Void) {
        let logoutURL: String = baseURL + "/sign_out"
        
        HTTPDeleteJSON(logoutURL) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
        
            if (error != nil) {
                callback(false,error)
            } else {
                self.wipeOutUserEmailAndPasswordFromKeychain()
                callback(true,nil)
            }
        }
    }
    
    func validateHeader(callback: (Bool) -> Void) {
        let validateURL: String = baseURL + "/validate_token"        
        HTTPGetJSON(validateURL) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                callback(false)
            } else {
                callback(true)
            }
        }
    }
    
}