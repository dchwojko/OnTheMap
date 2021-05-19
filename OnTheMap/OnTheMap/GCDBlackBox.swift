//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/13/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}