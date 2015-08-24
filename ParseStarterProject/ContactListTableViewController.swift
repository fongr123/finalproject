//
//  ContactListTableViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
import Parse

class ContactListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    var friendList: NSMutableArray = []
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var addressBook: ABAddressBookRef?
    var contactList: NSArray = []
    var parseIdentifierArray:NSMutableArray = NSMutableArray()
    var filteredContact = [ABRecordRef]()
    var addresBookIdentifierArray: NSMutableArray = NSMutableArray()
    var fromWho = ""
    var selfIdentifier = ""
    
    
    override func viewDidAppear(animated: Bool) {
        
        var query = PFQuery(className: "Person")
        //query.orderByAscending("dueAt")
        
        //query.whereKey("recipients", containsAllObjectsInArray: ["+85212345678"])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.friendList.removeAllObjects()
                
                if let objects = objects as? [PFObject] {
                    self.friendList.addObjectsFromArray(objects)
                    
                }
                
            }
            self.tableView.reloadData()
        }
    }

    
    
  /*  func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredContact = self.contactList.filter({( candy: Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }

    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       var query = PFQuery(className: "Person")
//        query.whereKey("identifier", containsAllObjectsInArray: ["+85212345678"])
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                    if let objects = objects as? [PFObject] {
                    for person in objects {
                        self.parseIdentifierArray.addObject(person["identifier"]!)
                    }
                }
            }
        }
        test()
        
    }
    
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func test() {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.NotDetermined) {
            println("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                }
                else {
                    println("error")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Restricted) {
            println("access denied")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized) {
            println("access granted")
            self.getContactNames()
        }
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        self.contactList = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        self.tableView.reloadData()
        //println("records in the array \(self.contactList.count)")
        
        for record:ABRecordRef in contactList {
            var contactPerson: ABRecordRef = record
            var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
            
//            let emailProperty: ABMultiValueRef = ABRecordCopyValue(contactPerson, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
//            let allEmailIDs: NSArray = ABMultiValueCopyArrayOfAllValues(emailProperty).takeUnretainedValue() as NSArray
//            println ("contactName \(contactName)")
//            for email in allEmailIDs {
//                let emailID = email as! String
//                println ("contactEmail : \(emailID) :=>")
//            }

            let phoneProperty: ABMultiValueRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
            let allPhoneIDs: NSArray = ABMultiValueCopyArrayOfAllValues(phoneProperty).takeUnretainedValue() as NSArray
           // println ("contactName \(contactName)")
            for phone in allPhoneIDs {
                let phoneID = phone as! String
                //println ("contactPhone : \(phoneID) :=>")
                var newPhoneID = phoneID.stringByReplacingOccurrencesOfString("(", withString: "", options:NSStringCompareOptions.LiteralSearch, range: nil)
                    newPhoneID = newPhoneID.stringByReplacingOccurrencesOfString(")", withString: "", options:NSStringCompareOptions.LiteralSearch, range: nil)
                    newPhoneID = newPhoneID.stringByReplacingOccurrencesOfString(" ", withString: "", options:NSStringCompareOptions.LiteralSearch, range: nil)
                    newPhoneID = newPhoneID.stringByReplacingOccurrencesOfString("-", withString: "", options:NSStringCompareOptions.LiteralSearch, range: nil)
                    self.addresBookIdentifierArray.addObject(newPhoneID)
                //println ("contactPhone : \(newPhoneID) :=>")
            }
            
            
        }
    }
    
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    println("Just denied")
                } else {
                    println("Just authorized")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.friendList.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ContactListTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ContactListTableViewCell
        
        var texta = friendList[indexPath.row]["firstName"] as? String
        var textb = friendList[indexPath.row]["lastName"] as? String
        
        if let text = "\(texta!) \(textb!)" as? String {
            cell.personName.adjustsFontSizeToFitWidth = true
            cell.personName.font = UIFont.systemFontOfSize(14.0)
            cell.personName.numberOfLines = 1
            cell.personName.text = text
            
            }
        
        
        
        
        
        
        
        
       /*
        var contactPerson:ABRecordRef = self.contactList[indexPath.row];
        var contactName: String = ABRecordCopyCompositeName(contactPerson).takeRetainedValue() as String
        
        var thumbnailData = ABPersonCopyImageData(contactPerson).takeRetainedValue() as NSData
        if let pic = UIImage(data: thumbnailData) {
            cell.profilePic.image = pic
        }
        */
        //cell.personName!.text = contactName
        
        return cell
        
        
    }
    
    
    @IBAction func pushButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("push", sender: self)
        
    }
    

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        var destinationVC = segue.destinationViewController as! AddNewReminderViewController
    
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            destinationVC.toWho = friendList[indexPath.row]["identifier"] as! String
            destinationVC.selfIdentifier = self.selfIdentifier
            
        }
    }
    
    
    @IBAction func meButton(sender: AnyObject) {
        
        
    }

   
}
