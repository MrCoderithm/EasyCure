//
//  AppointmentsViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit
import Firebase
class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tbAppointments : UITableView!
    @IBOutlet var lblEmail : UILabel!
    var BookingList = [BookingModel]()
    var aptRef : DatabaseQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmail.text = Auth.auth().currentUser?.email!
        
        
        aptRef = Database.database().reference().child("BookedAppointment")
            //.queryOrdered(byChild: "userEmail").queryEqual(toValue : Auth.auth().currentUser?.email!)
        
        aptRef.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount > 0{
                self.BookingList.removeAll()
                for bookings in snapshot.children.allObjects as![DataSnapshot]{
                    let bookingObject = bookings.value as? [String : AnyObject]
                    let bookingEmail = bookingObject?["userEmail"]
                    let bookingString = bookingObject?["Booking"]
                    
                    let booking = BookingModel(UserEmail: bookingEmail as? String, Booking: bookingString as? String)
                    
                    self.BookingList.append(booking)
                }
                 self.tbAppointments.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DoctorTableViewCell
        let booking : BookingModel
        booking = BookingList[indexPath.row]
        cell.lblName.text = booking.UserEmail
        cell.lblProf.text = booking.Booking
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

}

