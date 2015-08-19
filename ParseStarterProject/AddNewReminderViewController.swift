//
//  AddNewReminderViewController.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AddNewReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var reminderText: UITextField!

    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBAction func scheduleReminderButton(sender: AnyObject) {
        var dueDate:NSDate = self.dueDatePicker.date
        var remindeer = PFObject(className: "Reminder")
        remindeer["dueAt"] = self.dueDatePicker.date
        remindeer["text"] = reminderText.text
        remindeer["recipients"] = ["+85212345678","+85287654321"]
        remindeer.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
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
