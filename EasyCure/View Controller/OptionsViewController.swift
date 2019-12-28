//
//  OptionsViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

class OptionsViewController: UIViewController {
    
     @IBOutlet var lblUserName : UILabel!

    @IBAction func unwindToHomeVC (sender: UIStoryboardSegue){}
    
     var userRef:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser?.uid
        userRef = Database.database().reference().child("Users").child(userID!)
        
       
        userRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = snapshot.value as? NSDictionary
            let userName = userObject?["UserName"]
            self.lblUserName.text = ("Welcome ")

            let Name = userName as? String
            
            self.lblUserName.text = (self.lblUserName.text ?? "") + Name!
           
        }) { (error) in
            print(error.localizedDescription)
        }
       

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    

}
