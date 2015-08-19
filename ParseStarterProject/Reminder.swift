//
//  Reminder.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AddressBook

class Reminder: NSObject {
    
    var text = ""
    var dueTime: NSDate = NSDate()
    var fromWho:Int32 = Int32()
    var toWhoList=[Int32]()
    var isComplete = false
    var creator:Int32 = Int32()
    var pastDue = false
    
    
    func dueTimeToString() -> String {
        
        let date = dueTime
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let string = dateFormatter.stringFromDate(date)
        
        return string
        
    }
   
}
