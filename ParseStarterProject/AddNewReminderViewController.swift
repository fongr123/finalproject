//
//  AddNewReminderViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AddNewReminderViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reminderText.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var reminderText: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (range.length + range.location > count(textField.text) )
        {
            return false;
        }
        
        let newLength = count(textField.text) + count(string) - range.length
        return newLength <= 80
    }
    


    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBAction func scheduleReminderButton(sender: AnyObject) {
        
        if (reminderText.text != nil) {
        
        var dueDate:NSDate = self.dueDatePicker.date
        var remindeer = PFObject(className: "Reminder")
        remindeer["dueAt"] = self.dueDatePicker.date
        remindeer["text"] = reminderText.text
        remindeer["recipients"] = ["+85212345678","+85287654321"]
        remindeer.saveInBackground()
        
        let alert = UIAlertView()
        alert.title = "Success"
        alert.message = "Reminder Scheduled."
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        self.performSegueWithIdentifier("returnToMainMenu", sender: self)
        }
        
        else {
            
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "No reminder field is empty"
            alert.addButtonWithTitle("Ok")
            alert.show()
    
        }

        
        
        //self.performSegueWithIdentifier("goToMainMenuViewController", sender: self)
        
    }

   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! MainMenuViewController
        
        destinationVC.
    }
*/
    
    
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
