//
//  ViewController.swift
//  ParseChat
//
//  Created by Eric Suarez on 2/4/16.
//  Copyright © 2016 Eric Suarez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func signUp(sender: AnyObject) {
    
            var user = PFUser()
            user.username = emailTextField.text
            user.password = passwordTextField.text
            user.email = emailTextField.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    
                    self.displayAlert("Login Failed", message: (errorString as? String)!)
                    
                } else {
                    // Hooray! Let them use the app now.
                    
                    self.performSegueWithIdentifier("successfulLogin", sender: self)
                }
            }
    }
    
    @IBAction func login(sender: AnyObject) {
        
        var errorMessage = "Please try again later"
        
        PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            
//            self.activityIndicator.stopAnimating()
//            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("successfulLogin", sender: self)
                
            } else {
                // The login failed. Check error to see why.
                
                if let errorString = error!.userInfo["error"] as? String {
                    
                    errorMessage = errorString
                    
                }
                
                self.displayAlert("Login Failed", message: errorMessage)
                
            }
        }
        
    }
    

}

