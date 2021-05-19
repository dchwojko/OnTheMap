//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/13/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

extension UdacityClient {
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let session = "/session"
        static let userId = "/users/{id}"
    }
}