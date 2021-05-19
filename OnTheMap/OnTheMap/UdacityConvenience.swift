//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/13/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func udacityURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        let components = NSURLComponents()
        components.scheme = "https" // UdacityClient.Constants.APIScheme
        components.host = "udacity.com" // UdacityClient.Constants.APIHost
        components.path = "/some_path" // UdacityClient.Constants.APIPath
        components.queryItems = [NSURLQueryItem]()
        for (key,value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.URL!

    }
    
    func authenticateUser(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        taskForPOSTMethod(username, password: password) { (result, error) in
            
            if (result != nil) {
                if let account = result["account"] {
                    self.userId = account!["key"] as? String
                    self.getUserData(self.userId!) { (success, errorString) in
                        if success {
                            completionHandler(success: true, errorString: nil)
                        } else {
                            
                            completionHandler(success: false, errorString: "\(error!.localizedDescription)")
                        }
                    }
                    
                }
            } else {
                completionHandler(success: false, errorString: "\(error!.localizedDescription)")
            }
            
        }
        
    }
    
    func getUserData(id: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForGETMethod(id) { (result, error) in
            if (result != nil) {
                if let user = result!["user"] {
                    if let firstName = user!["first_name"] {
                        self.firstName = firstName! as? String
                    }
                    if let lastName = user!["last_name"] {
                        self.lastName = lastName as? String
                    }
                }
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "some error")
            }
        }
    }
    
    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForDELETEMethod() { (result, error) in
            if (result != nil) {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "There was an error logging out")
            }
            
            
        }
        
        
    }
    
}