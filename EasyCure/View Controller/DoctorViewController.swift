//
//  DoctorViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit
import Firebase

class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var docRef : DatabaseReference!
    @IBOutlet var tbDoctors : UITableView!
    var DoctorsList = [DoctorModel]()
    var nameToPass = ""
    @IBAction func unwindToDoctorsVC (sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        docRef = Database.database().reference().child("Doctors")
        
        docRef.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount > 0{
                self.DoctorsList.removeAll()
                for doctors in snapshot.children.allObjects as![DataSnapshot]{
                    let doctorObject = doctors.value as? [String : AnyObject]
                    let doctorName = doctorObject?["Name"]
                    let doctorProf = doctorObject?["Profession"]
                    let doctorId = doctorObject?["DocID"]
                    
                    let doctor = DoctorModel(DocID: doctorId as? String, Name: doctorName as? String, Profession: doctorProf as? String)
                    
                    self.DoctorsList.append(doctor)
                }
                 self.tbDoctors.reloadData()
            }
        })
        
        
        // Do any additional setup after loading the view.
    }
    
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DoctorTableViewCell
         let doctor : DoctorModel
         doctor = DoctorsList[indexPath.row]
         cell.lblName.text = doctor.Name
         cell.lblProf.text = doctor.Profession
         
         return cell
     }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return DoctorsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.nameToPass = DoctorsList[indexPath.row].Name!
        
        performSegue(withIdentifier: "AptSegue", sender: self)
     
 
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AptSegue"){
            let vc = segue.destination as! BookingViewController
            vc.docName = self.nameToPass
        }
         
     }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
