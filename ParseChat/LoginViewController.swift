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
    
    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.DismissKeyboard))
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

    @IBAction func signUp(_ sender: AnyObject) {
    
        var user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackground(block: { (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                let errorString = error.localizedDescription as? NSString
                // Show the errorString somewhere and let the user try again.
                
                self.displayAlert("Login Failed", message: (errorString as? String)!)
                
            } else {
                // Hooray! Let them use the app now.
                
                self.performSegue(withIdentifier: "successfulLogin", sender: self)
            }
        })
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        var errorMessage = "Please try again later"
        
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: Error?) -> Void in
            
//            self.activityIndicator.stopAnimating()
//            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // Do stuff after successful login.
                self.performSegue(withIdentifier: "successfulLogin", sender: self)
                
            } else {
                // The login failed. Check error to see why.
                
                if let errorString = error!.localizedDescription as? String {
                    
                    errorMessage = errorString
                    
                }
                
                self.displayAlert("Login Failed", message: errorMessage)
                
            }
        }
        
    }
    

}

