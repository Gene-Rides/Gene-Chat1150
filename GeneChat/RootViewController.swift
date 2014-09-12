//
//  ViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/10/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource , PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate
{
    
    var redViewController : RedViewController!
    var cameraViewController : CameraViewController!
    var friendsViewController : FriendsViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.redViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("redViewController") as? RedViewController
        self.redViewController.title = "Red"
        
        self.cameraViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("cameraViewController") as? CameraViewController
        self.cameraViewController.title = "Camera"
        
        self.friendsViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("friendsViewController") as? FriendsViewController
        self.friendsViewController.title = "Friends"
        
        var startingViewControllers : NSArray = [self.cameraViewController]
        
        self.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuth()
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        //        println(viewController.title!)
        switch viewController.title! {
        case "Red":
            return nil
        case "Camera":
            return redViewController
        case "Friends":
            return cameraViewController
        default:
            return nil
            
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        //        println(viewController.title!)
        switch viewController.title! {
        case "Red":
            return cameraViewController
        case "Camera":
            return friendsViewController
        case "Friends":
            return nil
        default:
            return nil
        }
    }
    
        func checkAuth() {
            
            // Check if somone is loged in ...
            if ChatUser.currentUser() == nil {
                // 1: Create and show login  controller
                var loginViewController = PFLogInViewController()
                loginViewController.delegate = self
                
                // 2: Hide cancel button
                loginViewController.fields = PFLogInFields.UsernameAndPassword
                    | PFLogInFields.LogInButton
                    | PFLogInFields.SignUpButton
                    | PFLogInFields.PasswordForgotten
                
                // 3: Customize the logo
                var logo = UIImage(named: "Logo")
                loginViewController.logInView.logo = UIImageView(image: logo)
                
                // 4" Create the sign up view Controller
                var signUpViewController = PFSignUpViewController()
                signUpViewController.fields = PFSignUpFields.UsernameAndPassword
                    | PFSignUpFields.Email
                    | PFSignUpFields.Additional
                    | PFSignUpFields.SignUpButton
                    | PFSignUpFields.DismissButton
                signUpViewController.delegate = self
                
                // 5: Customize the signup logo
                signUpViewController.signUpView.logo = UIImageView(image: logo)
                
                // 6: Reporpose
                var signupColor = UIColor.lightGrayColor()
                var additionalFieldText = NSAttributedString (string: "Phone Number", attributes: [NSForegroundColorAttributeName : signupColor])
                signUpViewController.signUpView.additionalField.attributedPlaceholder = additionalFieldText
                
                // 7 Mke the LIVC the SUVC
                loginViewController.signUpController = signUpViewController
                
                // 8 Make the SUVC appear
                self.presentViewController(loginViewController, animated: true, completion: nil)
                
                
                
            }
        }
    
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        if username != nil && password != nil && countElements(username) != 0 && countElements(password) != 0 {
            return true // Begin login process
        }
        
        if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
            
            var alert = UIAlertController(title: "Error", message: "Username and Password are required!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Error", message: "Username and Password are required!", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        return false
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        
        if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
            
            var alert = UIAlertController(title: "Login Failed", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Login Failed", message: "Please check your username and password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        
        var eInfo = info as NSDictionary
        var infoComplete = true
        
        for (key,val) in eInfo {
            if let field = eInfo.objectForKey(key) as? NSString {
                if field.length == 0 {
                    infoComplete = false
                    break
                }
            }
        }
        
        if !infoComplete {
            if let ios8Alert: AnyClass = NSClassFromString("UIAlertController") {
                
                var alert = UIAlertController(title: "Signup Failed", message: "All fields are required", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertView(title: "Signup Failed", message: "All fields are required", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        
        return infoComplete
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

