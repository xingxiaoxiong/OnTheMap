//
//  SLClient.swift
//  OnTheMap
//
//  Created by shapeare on 7/6/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import Foundation

class SLClient : NSObject {
    
    var session: NSURLSession
    
    var sessionID : String? = nil
    var userID : String? = nil
    var lastName : String? = nil
    var firstName : String? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = method + SLClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
    
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                let newError = SLClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                SLClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForParseGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = SLClient.Constants.ParseBaseURL + method + SLClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(SLClient.Constants.ParseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(SLClient.Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                let newError = SLClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                SLClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = method + SLClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if let error = error {
                let newError = SLClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: error)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                SLClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
  
        }
        
        task.resume()
        
        return task
    }
    
    
    func taskForParsePOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = SLClient.Constants.ParseBaseURL + method + SLClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(SLClient.Constants.ParseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(SLClient.Constants.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            
            if let error = error {
                let newError = SLClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: error)
            } else {
                SLClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "Udacity Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> SLClient {
        
        struct Singleton {
            static var sharedInstance = SLClient()
        }
        
        return Singleton.sharedInstance
    }
}