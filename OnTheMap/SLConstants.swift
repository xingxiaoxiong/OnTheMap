//
//  SLConstants.swift
//  OnTheMap
//
//  Created by shapeare on 7/6/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import Foundation

extension SLClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseAppId : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let AuthorizationURL : String = "https://www.udacity.com/api/session"
        static let ParseBaseURL : String = "https://api.parse.com/1/classes/StudentLocation"
        
        // MARK: Parse
        static let LocationLimit : Int = 100
        static let CreatedAt = "-createdAt"
        
        // MARK: Error
        static let DownloadError = "Error downloading data"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let Account = "https://www.udacity.com/api/users/{id}"
        
        // MARK: Authentication
        static let AuthenticationSessionNew = "https://www.udacity.com/api/session"
        
        // MARK: Parse
        static let Parse = ""
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        
        static let Username = "username"
        static let Password = "password"
        
        static let LocationLimit = "limit"
        static let Order = "order"
        
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let Session = "session"
        static let SessionID = "id"
        static let Error = "error"
        
        // MARK: Account
        static let UserAccount = "account"
        static let UserID = "id"
        static let UserDetail = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
        
        // MARK: Student Location
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        
        static let GetLocations = "results"
        
    }
    
}