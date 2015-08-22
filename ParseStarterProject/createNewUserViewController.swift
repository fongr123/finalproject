//
//  createNewUserViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class createNewUserViewController: UIViewController {
    
    
    var person = PFObject (className: "Person")
    var reminder = PFObject (className: "Reminder")
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUpSuccess (Firstname: String, Lastname: String, Phonenumber: String)-> Bool {
        if (Phonenumber != "" ) && (Firstname != "") && (Lastname != "") {
            return true
        }
        else
        {return false}
    }
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    
    
    
    
    
    /*
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneNumber
        {
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("852 ")
                index += 1
            }
            if (length - index) > 4
            {
                var areaCode = decimalString.substringWithRange(NSMakeRange(index, 4))
                formattedString.appendFormat("(%@)", areaCode)
                index += 4
            }
            if length - index > 4
            {
                var prefix = decimalString.substringWithRange(NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
            }
            
            var remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString
            return false
        }
        else
        {
            return true
        }
    }
    */
    
    @IBAction func signUpButton(sender: AnyObject) {
        if (signUpSuccess( firstName.text, Lastname: lastName.text, Phonenumber: phoneNumber.text) == true) {
            
            person["firstName"] = firstName.text
            person["identifier"] = phoneNumber.text
            person["lastName"] = lastName.text
            person["isRegistered"] = true
            person.saveInBackground()
            
            
            
            let alert = UIAlertView()
            alert.title = "Success"
            alert.message = "Congratulations \(firstName.text)! Your sign up is successful!"
            alert.addButtonWithTitle("Ok")
            alert.show()

            
            
        self.performSegueWithIdentifier("signUpSuccess", sender: self)
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
