//
//  createNewContactViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class createNewContactViewController: UIViewController {
    
    var person = PFObject (className: "Person")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var identifier: UITextField!
    
    
    func signUpSuccess (Firstname: String, Lastname: String, Phonenumber: String)-> Bool {
        if (Phonenumber != "" ) && (Firstname != "") && (Lastname != "") {
            return true
        }
        else
        {return false}
    }

    @IBAction func createContact(sender: AnyObject) {
    
    
    if (signUpSuccess( firstName.text, Lastname: lastName.text, Phonenumber: identifier.text) == true) {
    
    person["firstName"] = firstName.text
    person["identifier"] = identifier.text
    person["lastName"] = lastName.text
    person["isRegistered"] = false
    person.saveInBackground()
    
    
    
    let alert = UIAlertView()
    alert.title = "Success"
    alert.message = "contact added to Contacts"
    alert.addButtonWithTitle("Ok")
    alert.show()
    
    
    //self.dismissViewControllerAnimated(true, completion: {})
    self.dismissViewControllerAnimated(true, completion: {})
    }
    
    else {
    
    let alert = UIAlertView()
    alert.title = "Error"
    alert.message = "One or more required fields have not been filled in."
    alert.addButtonWithTitle("Retry")
    alert.show()
    
    
        }
        
    }


    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
