//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Eric Suarez on 2/4/16.
//  Copyright © 2016 Eric Suarez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [String]()
    var usernameArray = [String]()
    
    func onTimer() {
        // Add code to be run periodically
        
        var query = PFQuery(className:"Message")
        query.orderByDescending("createdAt")
        //query.includeKey("user")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object["text"])
                        self.messageArray.append(object["text"] as! String)
                        //self.usernameArray.append(object["user"].username!! as String)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        onTimer()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMessage(sender: AnyObject) {
        
        var message = PFObject(className:"Message")
        message["text"] = messageTextField.text
        //message["user"] = PFUser.currentUser()
                message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print(message)
            } else {
                // There was a problem, check error.description
                print(error)
            }
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatCell
        
        cell.messageLabel.text = messageArray[indexPath.row]
        //cell.usernameLabel.text = usernameArray[indexPath.row]
        
        return cell
    }

}
