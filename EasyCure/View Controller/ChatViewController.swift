//
//  ChatViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//


import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    //declare empty array for messages
    var msgArray : [Message] = [Message]()
    
    @IBAction func unwindToHomeVC (sender: UIStoryboardSegue){}
    
    //Components
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var msgTextfield: UITextField!
    @IBOutlet var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgTableView.delegate = self
        msgTableView.dataSource = self
        
        msgTextfield.delegate = self
        
        //on tap use tableViewTap function and add to tableView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTap))
        msgTableView.addGestureRecognizer(tap)
        
        //Use the custom made cell
        msgTableView.register(UINib(nibName: "MessageCell", bundle:nil), forCellReuseIdentifier: "customMessageCell")
        
        configTableView()
        getMessages()
        msgTableView.separatorStyle = .none
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //set cell to the msg in the database
        cell.messageBody.text = msgArray[indexPath.row].msgBody
        //set sender to the sender in the database
        cell.senderUsername.text = msgArray[indexPath.row].sender
        //update image to egg avatar
        cell.avatarImageView.image = UIImage(named: "egg")
        
        //if the person sending the text is current user in the database
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{
            //update avatar and cell backgrounds
            cell.avatarImageView.backgroundColor = UIColor.flatGreen()
            cell.messageBackground.backgroundColor = UIColor.flatRed()
        }
        else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatMagenta()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of cells in accordance to number of messages in array
        return msgArray.count
    }
    
    
    @objc func tableViewTap(){
        msgTextfield.endEditing(true)
    }
    
    //function to configure table view, setting  it to automatic or an estimated of 120
    func configTableView(){
        msgTableView.rowHeight = UITableView.automaticDimension
        msgTableView.estimatedRowHeight = 120.0
    }

    //bring the message type to a larger size (308)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.4){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    //bring the message typing back down to 50
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    // Action for when Send is pressed
    @IBAction func sendPressed(_ sender: AnyObject) {
        //editing is done
        msgTextfield.endEditing(true)
        //disable text and button
        msgTextfield.isEnabled = false
        sendBtn.isEnabled  = false
        //connect to database
        let msgDB = Database.database().reference().child("Messages")
        //create dictionary with sender and message
        let msgDict = ["Sender": Auth.auth().currentUser?.email, "MessageBody": msgTextfield.text!]
        //create unique ID for each message and attach individual dictionary to each key
        msgDB.childByAutoId().setValue(msgDict){
            (error, referenece) in
            //print error if its there
            if(error != nil){
                print(error!)
            }
            else{
                //enable text and button and reset text field
                print("Message Saved")
                self.msgTextfield.isEnabled = true
                self.sendBtn.isEnabled  = true
                self.msgTextfield.text = ""
            }
        }
        
        
    }
    //function to get the messages from the database
    func getMessages(){
        //connect to database
        let msgDB = Database.database().reference().child("Messages")
        msgDB.observe(.childAdded) { (snapshot) in
            let snapVal = snapshot.value as! Dictionary<String, String>
            //store message and sender in constants
            let txt = snapVal["MessageBody"]!
            let sender = snapVal["Sender"]!
            //update properties in Message object to update message and sender
            let msg = Message()
            msg.msgBody = txt
            msg.sender = sender
            //update array
            self.msgArray.append(msg)
            //reload the tableview
            self.configTableView()
            self.msgTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
}
