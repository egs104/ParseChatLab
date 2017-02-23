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
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
//                self.usernameArray = [String]()
//                self.messageArray = [String]()
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //print(object)
                        print(self.usernameArray)
                        print(self.messageArray)
                        
                        let messageText = object["text"] as? String
                        
                        if let messageText = messageText {
                            self.messageArray.append(object["text"] as! String)
                        } else {
                            self.messageArray.append(" ")
                        }
                        
                        var messageAuthor = object["user"]
                        
                        if let messageAuthor = messageAuthor {
                            self.usernameArray.append((object["user"] as AnyObject).username!! as String)
                        } else {
                            self.usernameArray.append(("anonymous"))
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        onTimer()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMessage(_ sender: AnyObject) {
        
        var message = PFObject(className:"Message")
        message["text"] = messageTextField.text
        message["user"] = PFUser.current()
                message.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print(message)
            } else {
                // There was a problem, check error.description
                print(error)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if messageArray != nil {
            return messageArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.messageLabel.text = messageArray[indexPath.row]
        cell.usernameLabel.text = usernameArray[indexPath.row]
        
        return cell
    }

}
