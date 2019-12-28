//
//  BookingViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class BookingViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    var docName = ""
    @IBOutlet var lblName : UILabel!
    @IBOutlet var appointmentPicker : UIPickerView!
    @IBOutlet var lblBooking : UILabel!
    var selectedRow = ""
    var AptRef : DatabaseQuery!
    var AptList = [AppointmentModel]()
    var ref:DatabaseReference?
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        lblName.text = docName
        AptRef = Database.database().reference().child("Appointment")
            //.queryOrdered(byChild: "Name").queryEqual(toValue : docName)
        
        AptRef.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount > 0{
                self.AptList.removeAll()
                for appointments in snapshot.children.allObjects as![DataSnapshot]{
                    let appointmentObject = appointments.value as? [String : AnyObject]
                    let appointmentName = appointmentObject?["Name"]
                    let appointmentDay = appointmentObject?["Day"]
                    let appointmentID = appointmentObject?["DocID"]
                    let appointmentTime = appointmentObject?["Time"]
                    
                    let appointment = AppointmentModel(DocID: appointmentID as? String, Name: appointmentName as? String, Day: appointmentDay as? String, Time: appointmentTime as! String)
                    
                    self.AptList.append(appointment)
                    
                    
                    let uid = Auth.auth().currentUser?.uid
                    self.ref?.child("BookedApt").child(uid!).child("userEmail").setValue(appointmentName)
                    self.ref?.child("BookedApt").child(uid!).child("Booking").setValue(appointmentDay)
                }
                self.appointmentPicker.reloadAllComponents()
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = self.title!
    }
    
    @IBAction func BookAppointment(){
        lblBooking.text = ("Booked Appointment with " + selectedRow)
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AptList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(37)))
            label.textAlignment = .left

        if AptList.isEmpty == true {
             label.text = "Other"
             self.title = "Other"

            } else {

            switch row{
              case 0...AptList.count - 1:
                  let apt = self.AptList[row]
                  self.title = apt.Name! + " " + apt.Day! + " " + apt.Time!
                  label.text = self.title

            default:
                label.text = "Other"
                 self.title = "Other"
            }
        }
        return label
    }
    
}
