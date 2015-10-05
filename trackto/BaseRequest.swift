//
//  BaseRequest.swift
//  trackto
//
//  Created by Andrew Platkin on 9/10/15.
//  Copyright (c) 2015 Andrew Platkin. All rights reserved.
//

import Foundation
import KeychainAccess

class BaseRequest {
    
    func HTTPsendRequest(request: NSMutableURLRequest,callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler: {
            data, response, error in
            if error != nil {
                callback(Dictionary<String, AnyObject>(), error!.localizedDescription)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 503 {
                        callback(Dictionary<String, AnyObject>(),"There is a problem with our satellites (Our bad)")
                    } else {
                        var dict = Dictionary<String, AnyObject>();
                        
                        // Save off header info in Keychain for subsequent calls in
                        self.parseAuthHeaderAndSave(httpResponse.allHeaderFields)
                        
                        dict["data"]       = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                        dict["headers"]    = httpResponse.allHeaderFields
                        dict["statusCode"] = httpResponse.statusCode
                        callback(dict,nil)
                    }
                }
            }
        })
        task.resume()
    }
    
    func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        //let e: NSError?
        let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        do {
            let jsonObj = (try NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions(rawValue: 0))) as! Dictionary<String, AnyObject>
            if (jsonObj.isEmpty) {
                return Dictionary<String, AnyObject>()
            } else {
                return jsonObj
            }
        } catch {
            print("Error serializing JSON Obj for: \(jsonString)")
            return Dictionary<String, AnyObject>()
        }
    }
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = NSJSONWritingOptions.PrettyPrinted
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: options) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    func HTTPGetJSON(url: String,callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request = enrichRequest(request)
        
        HTTPsendRequest(request) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                callback(Dictionary<String, AnyObject>(), error)
            } else {
                var data       = self.JSONParseDict(response["data"] as! String)
                let headers    = response["headers"] as! NSDictionary
                let statusCode = response["statusCode"] as! Int
                
                var parsedResponse = Dictionary<String, AnyObject>()
                parsedResponse["data"]       = data
                parsedResponse["header"]     = headers
                parsedResponse["statusCode"] = statusCode
                
                if let internalErrorMessages = data["errors"] as? [String] {
                    callback(parsedResponse, internalErrorMessages[0])
                }
                
                callback(parsedResponse, nil)
            }
        }
    }
    
    func HTTPPostJSON(url: String,jsonObj: AnyObject, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        
        request = enrichRequest(request)
        
        let data: NSData = jsonObj.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody = data
        HTTPsendRequest(request) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                callback(Dictionary<String, AnyObject>(), error)
            } else {
                let data       = self.JSONParseDict(response["data"] as! String)
                let headers    = response["headers"] as! NSDictionary
                let statusCode = response["statusCode"] as! Int
                
                var parsedResponse = Dictionary<String, AnyObject>()
                parsedResponse["data"]       = data
                parsedResponse["header"]     = headers
                parsedResponse["statusCode"] = statusCode
                
                callback(parsedResponse, nil)
            }
        }
    }
    
    func HTTPDeleteJSON(url: String,callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "DELETE"
        
        request = enrichRequest(request)
        
        HTTPsendRequest(request) {
            (response: Dictionary<String, AnyObject>, error: String?) -> Void in
            if (error != nil) {
                callback(Dictionary<String, AnyObject>(), error)
            } else {
                let data       = self.JSONParseDict(response["data"] as! String)
                let headers    = response["headers"] as! NSDictionary
                let statusCode = response["statusCode"] as! Int
                
                var parsedResponse = Dictionary<String, AnyObject>()
                parsedResponse["data"]       = data
                parsedResponse["header"]     = headers
                parsedResponse["statusCode"] = statusCode
                
                callback(parsedResponse, nil)
            }
        }
    }
    
    func enrichRequest(request: NSMutableURLRequest) -> NSMutableURLRequest {
        // Set Base Header Fields
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set Header Fields Needed for Authentication
        let authHeader = retrieveAuthHeaderFromKeychain()
        if (!authHeader.accessToken.isEmpty) {
            request.addValue(authHeader.accessToken, forHTTPHeaderField: "access-token")
            request.addValue(authHeader.client,forHTTPHeaderField: "client")
            request.addValue(authHeader.expiry,forHTTPHeaderField: "expiry")
            request.addValue(authHeader.tokenType,forHTTPHeaderField: "token-type")
            request.addValue(authHeader.uid,forHTTPHeaderField: "uid")
        }
        
        request.timeoutInterval = 6.0
        
        return request
    }
    
    func retrieveAuthHeaderFromKeychain() -> AuthHeader {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        var authHeader: AuthHeader = AuthHeader()
        if let accessToken = try! keychain.getString("accessToken")  {
            if let client = try! keychain.getString("client") {
                if let expiry = try! keychain.getString("expiry") {
                    if let uid = try! keychain.getString("uid") {
                        authHeader = AuthHeader(
                            token: accessToken,
                            clientSrc: client,
                            expiryNum: expiry,
                            userId: uid
                        )
                    }
                }
            }
        }
        return authHeader
    }
    
    func parseAuthHeaderAndSave(header: NSDictionary) {
        if let accessToken = header["access-token"] as? String {
            if let client = header["client"] as? String {
                if let expiry = header["expiry"] as? String {
                    if let uid = header["uid"] as? String {
                        let headers = AuthHeader(token: accessToken, clientSrc: client, expiryNum: expiry, userId: uid)
                            self.saveAuthHeaderInKeychain(headers)
                    }
                }
            }
        }
    }
    
    func saveAuthHeaderInKeychain(header: AuthHeader) {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        keychain["accessToken"] = header.accessToken
        keychain["client"]      = header.client
        keychain["expiry"]      = header.expiry
        keychain["uid"]         = header.uid
    }
    
    func saveEmailAndPasswordInKeychain(email: String, password: String) {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        keychain["email"]    = email
        keychain["password"] = password
    }
    
    func retrieveEmailFromKeychain() -> String {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        do {
            if let email = try keychain.getString("email") {
                return email
            }
        } catch {
            print("Email Not Found in Keychain")
        }
        return ""
    }
    
    func retrievePasswordFromKeychain() -> String {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        do {
            if let password = try keychain.getString("password") {
                return password
            }
        } catch {
            print("Password Not Found in Keychain")
        }
        return ""
    }
    
    func wipeOutUserEmailAndPasswordFromKeychain() {
        let keychain = Keychain(service: "com.plattypuslabs.trackto")
        
        do {
            try keychain.remove("email")
            try keychain.remove("password")
        } catch let error {
            print(error)
        }
    }
}