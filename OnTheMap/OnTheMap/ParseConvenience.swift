//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/21/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        taskForGETMethod() { (result, error) in
            if (result != nil) {
                let results = result!["results"] as! NSArray
                for student in results {
                    let s = StudentInformation.init(dictionary: student as! NSDictionary)
                    StudentList.sharedInstance().list.append(s)
                }
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "there was an error getting student locations")
            }
        }
    }
    
    /* for posting a new student location */
    func postStudentLocation(student: StudentInformation,completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        taskForPOSTMethod(student) { (result, error) in
            if (result != nil) {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "There was an error posting your location")
            }
        }
    }

    /* for updating student location */
    func putStudentLocation(objectId: String, student: StudentInformation, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\":\(student.latitude), \"longitude\": \(student.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
}