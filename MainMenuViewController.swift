//
//  MainMenuViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AddressBook
import Parse


class MainMenuViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var contactList: NSArray = []
    var addressBook: ABAddressBookRef?
    var reminder: PFObject = PFObject(className: "")
    var reminderList: NSMutableArray = []
    var friendsReminderList: NSMutableArray = []
    var allDates:NSMutableArray = []
    var isForMe = true
    var parseIdentifierArray:NSMutableArray = NSMutableArray()
    var selfIdentifier = NSUserDefaults.standardUserDefaults().objectForKey("kLoggedInUserIdentifier")
    var fromWhoNameList: NSMutableArray = []
    var fromWhoIdentifierList: NSMutableArray = []
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let isloggedinObject: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("kLoggedInUserIdentifier")

        if (isloggedinObject == nil) {
            self.performSegueWithIdentifier("SignupNavSegue", sender: self)
        }
    }
    
    
    @IBAction func logOutButton(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().removeObjectForKey("kLoggedInUserIdentifier")
    NSUserDefaults.standardUserDefaults().synchronize()
    self.performSegueWithIdentifier("signOutSegue", sender: self)
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        
        // for safely unwrapping selfIdentifier
        if  selfIdentifier != nil {
            selfIdentifier = NSUserDefaults.standardUserDefaults().stringForKey("kLoggedInUserIdentifier")
        } else {
            selfIdentifier = ""
        }
        println("selfIdentifier: \(selfIdentifier)")


        // query for my reminders
        var query = PFQuery(className: "Reminder")
        query.orderByAscending("dueAt")
        query.whereKey("recipients", containsAllObjectsInArray: [selfIdentifier!])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.reminderList.removeAllObjects()
                
                if let objects = objects as? [PFObject] {
                    self.reminderList.addObjectsFromArray(objects)
                    
                }
   
            }
            self.tableView.reloadData()
        }
        
        // query for forfriends reminders
        var query2 = PFQuery(className: "Reminder")
        query2.orderByAscending("dueAt")
        query2.whereKey("recipients", notContainedIn: [selfIdentifier!])
        query2.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.friendsReminderList.removeAllObjects()
                
                if let objects = objects as? [PFObject] {
                    self.friendsReminderList.addObjectsFromArray(objects)
                    
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        var queryPeople = PFQuery(className: "Person")
        queryPeople.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var num = object["identifier"] as! String
                        var name = (object["firstName"] as! String) + " " + (object["lastName"] as! String)
                        self.nameDict[num] = name
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    
    var nameDict: [String:String] = [:]
    
    
    // NEED TO INSERT CODE TO FIND OUT WHERE THE REMINDERS ARE FROM!!
    

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func button(sender: AnyObject) {
        if (sender.tag == 0) {
            isForMe = true;
        } else {
            isForMe = false;
        }
        self.tableView.reloadData()
    }

    
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isForMe) {
            return self.reminderList.count;
        } else {
            return self.friendsReminderList.count;
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (isForMe){
            let cell:ReminderTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ReminderTableViewCell
            
           let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                var reminderToBeDeleted:PFObject = self.reminderList[indexPath.row] as! PFObject;
                reminderToBeDeleted.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    if (error != nil) {
                        // deletion failed
                        // we should show some kind of error message.
                    } else {
                        // deletion succeeded
                        self.reminderList.removeObjectAtIndex(indexPath.row)
                        self.tableView.reloadData()
                    }
                })
                return true
            })
            
            cell.rightButtons = [deleteButton]
            cell.leftSwipeSettings.transition = MGSwipeTransition.Border
            
            //fromWhoNameList Database
            if let identifier = reminderList[indexPath.row]["fromWho"] as? String {
            var query = PFQuery (className: "Person")
            query.whereKey("fromWho", containsAllObjectsInArray: [identifier])
                query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if (error == nil) {
                        self.fromWhoNameList.removeAllObjects()
                        
                        if let objects = objects as? [PFObject] {
                            self.fromWhoNameList.addObjectsFromArray(objects)
                            println(objects)
                        }
                    }
                }
                

            

            var texta = fromWhoNameList[indexPath.row]["firstName"] as? String
            var textb = fromWhoNameList[indexPath.row]["lastName"] as? String
            
            if let text = "\(texta!) \(textb!)" as? String {
                cell.reminderNameLabel.adjustsFontSizeToFitWidth = true
                cell.reminderNameLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderNameLabel.numberOfLines = 1
                cell.reminderNameLabel.text = text
                }
            }
            
            var number = (reminderList[indexPath.row]["fromWho"] as! [String])[0]
//            cell.reminderNameLabel.text = number
            if (number == selfIdentifier as! String) {
                cell.reminderNameLabel.text = "me"
            } else {
                cell.reminderNameLabel.text = nameDict[number]
            }
            

            //
            


            // Remindertext
            if let text = reminderList[indexPath.row]["text"] as? String {
                cell.reminderDetailsLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDetailsLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDetailsLabel.numberOfLines = 3
                cell.reminderDetailsLabel.text = text
               
            }
            
            // Datetext
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EE, h:mma " + "d, MMM"
            //            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            //            formatter.timeStyle = .MediumStyle
            
            if let time = reminderList[indexPath.row]["dueAt"] as? NSDate {
                cell.reminderDueTimeLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDueTimeLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDueTimeLabel.numberOfLines = 2
                cell.reminderDueTimeLabel.text = formatter.stringFromDate(time)
                
            }
            return cell
        }
            
        //For Friends TableView Cell Update
        
        else {
            
            let cell:ReminderTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ReminderTableViewCell
            
            let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                var reminderToBeDeleted:PFObject = self.friendsReminderList[indexPath.row] as! PFObject;
                reminderToBeDeleted.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    if (error != nil) {
                        // deletion failed
                        // we should show some kind of error message.
                    } else {
                        // deletion succeeded
                        self.friendsReminderList.removeObjectAtIndex(indexPath.row)
                        self.tableView.reloadData()
                    }
                })
                return true
            })
            
            cell.rightButtons = [deleteButton]
            cell.leftSwipeSettings.transition = MGSwipeTransition.Border
            
            
            // Remindertext
            if let text = friendsReminderList[indexPath.row]["text"] as? String {
                cell.reminderDetailsLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDetailsLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDetailsLabel.numberOfLines = 3
                cell.reminderDetailsLabel.text = text
                
            }
            var number = (friendsReminderList[indexPath.row]["recipients"] as! [String])[0]
//            cell.reminderNameLabel.text = number
            cell.reminderNameLabel.text = nameDict[number]
            
            // Datetext
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EE, h:mma " + "d, MMM"
            //            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            //            formatter.timeStyle = .MediumStyle
            
            if let time = friendsReminderList[indexPath.row]["dueAt"] as? NSDate {
                cell.reminderDueTimeLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDueTimeLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDueTimeLabel.numberOfLines = 2
                cell.reminderDueTimeLabel.text = formatter.stringFromDate(time)
                
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "1" {
            var destinationVC = segue.destinationViewController as! ContactListTableViewController
                destinationVC.selfIdentifier = self.selfIdentifier as! String
        }
      
    }
    
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        self.contactList = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
            //            var contactID:ABRecordID  = contactPerson.contactID.intValue
            
            //println ("contactName \(contactName)")
            //           println ("contactID \(contactID)")
        }
    }
    
    
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(self.allDates[section] as! NSDate);

        return dateString
    }
*/

    
    
    //        query.whereKey("identifier", containsAllObjectsInArray: ["+85212345678"])
    
    
    
    
    
    /*  self.getContactNames()
    imageURL.contentMode = UIViewContentMode.ScaleAspectFit
    if let checkedUrl = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
    downloadImage(checkedUrl)
    }
    println("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    */
    
    
    
    //        var thirdReminder:Reminder = Reminder();
    //        thirdReminder.text = "Reminder 101"
    //        thirdReminder.dueTime = NSDate()
    //        thirdReminder.fromWho = 0
    //
    //        friendsReminderList.addObject(thirdReminder);



//Get Profile Pic

/*  func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
completion(data: data)
}.resume()
}

func downloadImage(url:NSURL){
println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
getDataFromUrl(url) { data in
dispatch_async(dispatch_get_main_queue()) {
println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
imageURL.image = UIImage(data: data!)
}
}

}

*/

    //fromWhoText
    /*if let fromWhoIdentifier = reminderList[indexPath.row]["fromWho"] as? String! {
    
    if selfIdentifier == fromWhoIdentifier {
    cell.reminderNameLabel.text = "Me"
    }
    
    else {
    var query = PFQuery(className: "Person")
    query.whereKey("identifier", containsAllObjectsInArray:[fromWhoIdentifier])
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
    if (error == nil) {
    self.fromWhoNameList.removeAllObjects()
    if let objects = objects as? [PFObject] {
    self.fromWhoNameList.addObjectsFromArray(objects)
    
    }
    }
    }
    
    var texta = fromWhoNameList[indexPath.row]["firstName"] as? String
    var textb = fromWhoNameList[indexPath.row]["lastName"] as? String
    
    if let text = "\(texta!) \(textb!)" as? String {
    cell.reminderNameLabel.adjustsFontSizeToFitWidth = true
    cell.reminderNameLabel.font = UIFont.systemFontOfSize(12.0)
    cell.reminderNameLabel.numberOfLines = 1
    cell.reminderNameLabel.text = text
    }
    }
    }
    */
    

}
