//
//  NotesViewController.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/*Assignment : InClass05
 FileName : NotesViewController.swift
 Name: Prerana Singh
 */


import UIKit
import Firebase

class NotesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
   
    
   @IBOutlet var tableView: UITableView!
    var ref: DatabaseReference!
   var notesList = [Note]()
    var noteName = ""
    var bookId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user{
            let noteRef = ref.child("Notebooks").child(user.uid).child(bookId)
            noteRef.observe(.value, with:{ snapshot in
                self.notesList = []
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots{
                        if let noteDictionary = snap.value as? Dictionary<String, AnyObject>{
                            let key = snap.key
                            let name = noteDictionary["name"] as! String
                            let noteTimestamp = noteDictionary["created At"] as! String
                            
                            let note = Note(name: name, createdTime: noteTimestamp, noteId: key)
                            self.notesList.append(note)
                        }
                    }
                    print(self.notesList.description)
                    self.tableView.reloadData()
                }
            })
            
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        
        noteName = notesList[indexPath.row].name
        let labelName = cell.viewWithTag(1) as! UILabel
        labelName.text = noteName
        let noteDate = notesList[indexPath.row].createdTime
        let labelDate = cell.viewWithTag(2) as! UILabel
        labelDate.text = noteDate
        
       // let btnDelete = cell.viewWithTag(3) as! UIButton
       // btnDelete.tag = indexPath.row
       // btnDelete.addTarget(self, action:#selector(deleteRow(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func btnAddNotes(_ sender: Any) {
        let alertController = UIAlertController(title: "New Note", message: "Enter New Post Text", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default){ _ in
            if let txtField = alertController.textFields?.first,
                let note = txtField.text{
                print(note)
                // let notebookItem = NotebookItem(name:text,
                //                                created at: )
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let noteRef = Database.database().reference().child("Notebooks").child(user.uid).child(self.bookId)
                    noteRef.childByAutoId().setValue([
                        "name": note,
                        "created At":self.getTodayString()
                        ])
                    
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Note Text"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        let cell = (sender as AnyObject).superview!.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let noteId = self.notesList[(indexPath?.row)!].noteId
        print(noteId)
        let user = Auth.auth().currentUser
        if let user = user {
        let ref = Database.database().reference()
        let NotesRef = ref.child("Notebooks").child(user.uid).child(self.bookId).child(noteId)
        NotesRef.removeValue()
        print("deleted")
        }
        notesList.remove(at: (indexPath?.row)!)
        print(notesList.description)
        
        tableView.reloadData()
    
    }
   
    
/*@objc func deleteRow(_ sender: UIButton){
        print("button clicked")
        notesList.remove(at: sender.tag)
        tableView.reloadData()
    }*/
    
    

}
