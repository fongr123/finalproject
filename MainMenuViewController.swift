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
    
    var senderIdentifier = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
                var query = PFQuery(className: "Person")
        //        query.whereKey("identifier", containsAllObjectsInArray: ["+85212345678"])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    for person in objects {
                        self.parseIdentifierArray.addObject(person["identifier"] as! (String))
                    }
                }
                
                if let isloggedinObject = NSUserDefaults.standardUserDefaults().objectForKey("kLoggedInUserIdentifier") {
                    if self.parseIdentifierArray.containsObject(isloggedinObject) {
                        self.senderIdentifier = isloggedinObject as! String
                        
                        //NSUserDefaults.standardUserDefaults().setObject(userID.text, forKey: "kLoggedInUserIdentifier")
                        //  LOGOUT      NSUserDefaults.standardUserDefaults().removeObjectForKey("kLoggedInUserIdentifier")
                        self.performSegueWithIdentifier("goToMainMenuViewController", sender: self)
                    }
                    
                } else {
                    
                }

                
            }

        
       

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
    }
    
    
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
    


    @IBAction func logOutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("kLoggedInUserIdentifier")
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        var query = PFQuery(className: "Reminder")
        query.orderByAscending("createdAt")
        
        query.whereKey("recipients", containsAllObjectsInArray: ["+85212345678"])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.reminderList.removeAllObjects()
                
                if let objects = objects as? [PFObject] {
                    self.reminderList.addObjectsFromArray(objects)
                    
                }
                for reminder in self.reminderList {
                    let reminderDate: AnyObject? = reminder.objectForKey("dueAt")
                    if (!self.allDates.containsObject(reminderDate!)) {
                        self.allDates.addObject(reminderDate!)
                    }
                }

            }
            self.tableView.reloadData()
        }
    }
    
    
   
 
    
    

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

    
  /*  - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
    NSString *sectionName;
    switch (section)
    {
    case 0:
    sectionName = NSLocalizedString(@"mySectionName", @"mySectionName");
    break;
    case 1:
    sectionName = NSLocalizedString(@"myOtherSectionName", @"myOtherSectionName");
    break;
    // ...
    default:
    sectionName = @"";
    break;
    }
    return sectionName;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }

    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        self.contactList = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
//            var contactID:ABRecordID  = contactPerson.contactID.intValue
            
            println ("contactName \(contactName)")
//            println ("contactID \(contactID)")
        }
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
            
            
            let customButton = MGSwipeButton(title: "Custom!", backgroundColor: UIColor.blueColor(), callback: { (sender:MGSwipeTableCell!) -> Bool in
                
                println("custom!")
                
                return false
            })
            
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
            
        
    
            // Remindertext
            if let text = reminderList[indexPath.row]["text"] as? String {
                cell.reminderDetailsLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDetailsLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDetailsLabel.numberOfLines = 3
                cell.reminderDetailsLabel.text = text
               
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EE, h:mma " + "d, MMM"
            //formatter.dateStyle = NSDateFormatterStyle.LongStyle
            //formatter.timeStyle = .MediumStyle
            
            
            if let time = reminderList[indexPath.row]["dueAt"] as? NSDate {
                cell.reminderDueTimeLabel.adjustsFontSizeToFitWidth = true
                cell.reminderDueTimeLabel.font = UIFont.systemFontOfSize(12.0)
                cell.reminderDueTimeLabel.numberOfLines = 2
                cell.reminderDueTimeLabel.text = formatter.stringFromDate(time)
                
            }

            return cell
        }
        
        else {
            
            let cell:ReminderTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ReminderTableViewCell
            
            let deleteButton = MGSwipeButton(title: "Done", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
              /*  self.reminderList.removeObjectAtIndex(indexPath.row) */
                self.tableView.reloadData()
                return true
            })
            
            
            cell.rightButtons = [deleteButton]
            cell.leftSwipeSettings.transition = MGSwipeTransition.Border
            
            var reminder:Reminder = self.friendsReminderList[indexPath.row] as! Reminder
            cell.reminderDetailsLabel.text = reminder.text
            return cell
            
        }
        
      
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98;
    }
    
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(self.allDates[section] as! NSDate);

        return dateString
    }
*/


}
