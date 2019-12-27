//
//  NotesViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//
import UIKit

protocol NoteViewDelegate {
    func didUpdateNoteWithTitle(newTitle : String, andBody newBody : String)
}

class NotesViewController: UIViewController, UITextViewDelegate {
    
    var delegate : NoteViewDelegate?
    
    @IBOutlet weak var txtBody : UITextView!
    
    var strBodyText : String!
    
    @IBOutlet weak var btnDoneEditing : UIBarButtonItem!
    
    @IBAction func doneEditingBody() {
        self.txtBody.resignFirstResponder()
        self.btnDoneEditing.tintColor = UIColor.clear
        
        if self.delegate != nil {
            self.delegate!.didUpdateNoteWithTitle(newTitle: self.navigationItem.title!, andBody: self.txtBody.text)
        }
    }
    
    func textViewDidBeginEditing(_ textView : UITextView){
        self.btnDoneEditing.tintColor = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.delegate == nil{
            self.delegate!.didUpdateNoteWithTitle(newTitle: self.navigationController!.title!, andBody: self.txtBody.text!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtBody.delegate = self
        
        self.txtBody.text = self.strBodyText
        
        self.txtBody.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let components = self.txtBody.text.components(separatedBy: "\n")
        
        self.navigationItem.title = ""
        
        for item in components {
            if item.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count > 0 {
                self.navigationItem.title = item
                break
            }
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
