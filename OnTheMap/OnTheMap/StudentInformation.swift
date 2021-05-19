//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 4/3/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

struct StudentInformation {
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    init(dictionary: NSDictionary) {

        if let uniqueKey = dictionary["uniqueKey"] {
            self.uniqueKey = uniqueKey as? String
        }
        if let firstName = dictionary["firstName"] {
            self.firstName = firstName as? String
        }
        if let lastName = dictionary["lastName"] {
            self.lastName = lastName as? String
        }
        if let mapString = dictionary["mapString"] {
            self.mapString = mapString as? String
        }
        if let mediaURL = dictionary["mediaURL"] {
            self.mediaURL = mediaURL as? String
        }
        if let latitude = dictionary["latitude"] {
            self.latitude = latitude as? Double
        }
        if let longitude = dictionary["longitude"] {
            self.longitude = longitude as? Double
        }
        
    }
    
}