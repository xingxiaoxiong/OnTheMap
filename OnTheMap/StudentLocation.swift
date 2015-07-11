//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by shapeare on 7/6/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation: NSObject {
    
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary[SLClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[SLClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[SLClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[SLClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[SLClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[SLClient.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[SLClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[SLClient.JSONResponseKeys.longitude] as! Double
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}

extension StudentLocation: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
    
    var title: String? {
        return "\(firstName) \(lastName)"
    }
    
    var subtitle: String? {
        return "\(mediaURL)"
    }
    
}