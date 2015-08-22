//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse



class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    var parseIdentifierArray:NSMutableArray = NSMutableArray()
    var senderIdentifier = ""
    
    
   
    
    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "Person")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    for person in objects {
                        self.parseIdentifierArray.addObject(person["identifier"] as! (String))
                    }
                }
                
                
            }
        }
            
            
        
        
        
        
        
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.text = "Welcome to Poke, your friendly reminder app"
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        // Facebook Delegate Methods
        
        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            println("User Logged In")
            
            if ((error) != nil)
            {
                
                // Process error
            }
            else if result.isCancelled {
                // Handle cancellations
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                    
                }
            }
        }
        
        
        func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
            println("User Logged Out")
        }
        
        
    }
    
    
    
   


    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                
            }
        }
NSUserDefaults.standardUserDefaults().objectForKey("kLoggedInUserIdentifier")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    
    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var userID: UITextField!
    
    
/*
    func searchUserInParse (UserID: String) -> Int {
        
        var numObjects : Int = 0 // the num return objects from query
        
        var query = PFQuery(className:"Person")
        query.whereKey("identifier", equalTo: UserID)
        query.findObjectsInBackgroundWithBlock {
            (objects: AnyObject[]!, error: NSError!) -> Void in
            if !error {
                numObjects = objects.count
                println(numObjects) // at this point the value = 1
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo)
            }
        }
        println(numObjects) // at this point the value = 0
        
        return numObjects
    }

*/
    
    @IBAction func SignInbutton(sender: AnyObject) {
        
       if parseIdentifierArray.containsObject(userID.text) {
        senderIdentifier = userID.text
        NSUserDefaults.standardUserDefaults().setObject(userID.text, forKey: "kLoggedInUserIdentifier")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("kLoggedInUserIdentifier")
        self.performSegueWithIdentifier("goToMainMenuViewController", sender: self)
        }
            
       else{
        
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = "User ID incorrect"
        alert.addButtonWithTitle("Retry")
        alert.show()

        }
        
        
        
    
        
        }
        

    
        
        
    // Do any additional setup after loading the view, typically from a nib.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

