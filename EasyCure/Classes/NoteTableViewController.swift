//
//  NoteTableViewController.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController, NoteViewDelegate {
    
    
    var arrNotes = [[String:String]]()
    
    var selectedIndex = 0
    
    @IBAction func newNote(){
        let newDict = ["title" : "",
                       "body" : ""]
        
        arrNotes.insert(newDict, at: 0)
        
        self.tableView.reloadData()
        
        performSegue(withIdentifier: "showEditorSegue", sender: nil)
        
        self.selectedIndex = 0
        
        saveNotesArray()
        
        
    }
    
    func didUpdateNoteWithTitle(newTitle: String, andBody newBody: String) {
        self.arrNotes[self.selectedIndex]["title"] = newTitle
        self.arrNotes[self.selectedIndex]["body"] = newBody
        
        self.tableView.reloadData()
        
        saveNotesArray()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newNotes = UserDefaults.standard.array(forKey: "notes") as? [[String:String]]{
            arrNotes = newNotes
        }

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")!
        cell.textLabel!.text = arrNotes[indexPath.row]["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEditorSegue", sender: nil)
        self.selectedIndex = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let notesEditorVC = segue.destination as! NotesViewController
        notesEditorVC.navigationItem.title = arrNotes[self.selectedIndex]["title"]
        notesEditorVC.strBodyText = arrNotes[self.selectedIndex]["body"]
        notesEditorVC.delegate = self
    }

    func saveNotesArray(){
        UserDefaults.standard.set(arrNotes, forKey: "notes")
        UserDefaults.standard.synchronize()
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
