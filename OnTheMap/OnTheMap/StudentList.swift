//
//  StudentList.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 4/25/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

class StudentList : NSObject {
    
    var list = [StudentInformation]()
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentList {
        struct Singleton {
            static var sharedInstance = StudentList()
        }
        return Singleton.sharedInstance
    }
    
}