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

class MainMenuViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var contactList: NSArray = []
    var addressBook: ABAddressBookRef?
    var reminder: PFObject = PFObject(className: "")
    var reminderList: NSMutableArray = []
    var friendsReminderList: NSMutableArray = []
    var isForMe = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getContactNames()

//        var thirdReminder:Reminder = Reminder();
//        thirdReminder.text = "Reminder 101"
//        thirdReminder.dueTime = NSDate()
//        thirdReminder.fromWho = 0
//        
//        friendsReminderList.addObject(thirdReminder);
        
        
        

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
            
            if let text = reminderList[indexPath.row]["text"] as? String {
                cell.textLabel?.text = text
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


}
