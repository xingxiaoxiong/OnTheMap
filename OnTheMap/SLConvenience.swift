//
//  SLConvenience.swift
//  OnTheMap
//
//  Created by shapeare on 7/6/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit
import Foundation

extension SLClient {
    
    func authenticateWithViewController(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.getSessionID(username, password: password) { (success, sessionID, userID, errorString) in

            if success {
                self.sessionID = sessionID
                self.userID = userID
                
                self.getUserData() { (success, lastName, firstName, errorString) in
                    
                    if success {
                        self.lastName = lastName
                        self.firstName = firstName
                    }
                    
                    completionHandler(success: success, errorString: errorString)
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getSessionID(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        let parameters = [String: AnyObject]()
        let jsonBody : [String:AnyObject] = ["udacity":[
            SLClient.ParameterKeys.Username: username,
            SLClient.ParameterKeys.Password: password]
        ]
        taskForPOSTMethod(Methods.AuthenticationSessionNew, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in

            if let error = error {
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Error loging in")
            } else {
                if let error = JSONResult.valueForKey(SLClient.JSONResponseKeys.Error) as? String {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: error)
                } else {
                    if let session = JSONResult.valueForKey(SLClient.JSONResponseKeys.Session) as? [String: AnyObject] {
                        if let sessionID = session["id"] as? String{
                            if let account = JSONResult.valueForKey(SLClient.JSONResponseKeys.UserAccount) as? [String: AnyObject] {
                                if let userID = account["key"] as? String {
                                    completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                                } else {
                                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                                }
                            } else {
                                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                            }
                        } else {
                            completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                        }
                    } else {
                        completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                    }
                }
            }
        }
    }
    
    func getUserData(completionHandler: (success: Bool, lastName: String?, firstName: String?, errorString: String?) -> Void) {
        
        var parameters = [String: AnyObject]()
        var mutableMethod : String = Methods.Account
        mutableMethod = SLClient.subtituteKeyInMethod(mutableMethod, key: SLClient.URLKeys.UserID, value: String(SLClient.sharedInstance().userID!))!
        
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(success: false, lastName: nil, firstName: nil, errorString: "Login Failed (User name).")
            } else {
                if let userDetail = JSONResult.valueForKey(SLClient.JSONResponseKeys.UserDetail) as? [String: AnyObject] {
                    let lastName = userDetail[SLClient.JSONResponseKeys.LastName] as? String
                    let firstName = userDetail[SLClient.JSONResponseKeys.FirstName] as? String
                    if (lastName != nil && firstName != nil) {
                        completionHandler(success: true, lastName: lastName, firstName: firstName, errorString: nil)
                    }
                } else {
                    completionHandler(success: false, lastName: nil, firstName: nil, errorString: "Login Failed (User name).")
                }
            }
        }
    }
    
    func getLocations(completionHandler: (locations: [StudentLocation]?, error: String?) -> Void) {
        let parameters = [
            SLClient.ParameterKeys.LocationLimit: SLClient.Constants.LocationLimit,
            SLClient.ParameterKeys.Order: SLClient.Constants.CreatedAt
        ]
        var mutableMethod : String = Methods.Parse
        taskForParseGETMethod(mutableMethod, parameters: parameters as! [String : AnyObject]) { JSONResult, error in

            if let error = error {
                completionHandler(locations: nil, error: "Error getting locations.")
            } else {
                if let results = JSONResult.valueForKey(SLClient.JSONResponseKeys.GetLocations) as? [[String: AnyObject]] {
                    var locations = StudentLocation.locationsFromResults(results)
                    completionHandler(locations: locations, error: nil)
                } else {
                    completionHandler(locations: nil, error: "Error getting locations.")
                }
            }
        }
    }
    
    func postLocation(location: StudentLocation, completionHandler: (success: Bool, error: String?) -> Void) {
        var parameters = [String: AnyObject]()
        var mutableMethod : String = Methods.Parse
        let jsonBody : [String : AnyObject!] = [
            SLClient.ParameterKeys.UniqueKey: userID,
            SLClient.ParameterKeys.FirstName: firstName,
            SLClient.ParameterKeys.LastName: lastName,
            SLClient.ParameterKeys.MapString: location.mapString,
            SLClient.ParameterKeys.MediaURL: location.mediaURL,
            SLClient.ParameterKeys.Latitude: location.latitude,
            SLClient.ParameterKeys.Longitude: location.longitude
        ]
        taskForParsePOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            if let error = error {
                completionHandler(success: false, error: "Error posting locations.")
            } else {
                completionHandler(success: true, error: nil)
            }
        }
    }
    
    func logout(completionHandler: (success: Bool, error: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, error: "Error loging out")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            completionHandler(success: true, error: nil)
        }
        task.resume()
    }

}