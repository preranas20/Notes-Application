//
//  NotebooksViewController.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/13/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/*Assignment : InClass05
 FileName : NotebooksViewController.swift
 Name: Prerana Singh
 */


import UIKit
import Firebase

class NotebooksViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    var notebooksList = [Notebook]()
    var noteBookName = ""
    var bookname = ""
    var bookTimestamp = ""
    var bookKey = ""
    var userId = ""
    var bookId = ""
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("logout happening")
        tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   let userID = Auth.auth().currentUser!.uid
        tableView.reloadData()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        if((user) != nil){
        let user = Auth.auth().currentUser
        if let user = user{
            self.ref = Database.database().reference()
            let noteBooksRef = self.ref.child("Notebooks").child(user.uid)
        noteBooksRef.observe(DataEventType.value, with: {(snapshot) in
            print("\(snapshot)")
       
            if snapshot.childrenCount > 0{
               self.notebooksList.removeAll()
                
                for books in snapshot.children.allObjects as! [DataSnapshot]{
                    print(books.value)
                    self.bookKey = books.key
                    let bookObject = books.value as! [String: Any]
                    
                    self.bookname = bookObject["name"] as! String
                    self.bookTimestamp = bookObject["created At"] as! String
                    
                    let book = Notebook(name:self.bookname ,createdTime:self.bookTimestamp ,bookId:self.bookKey)
                    self.notebooksList.append(book)
                    
                }
                
                print(self.notebooksList.description)
                self.tableView.reloadData()
            }
        })
        }
        }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        print("logout happening")
        let user = Auth.auth().currentUser
        if user != nil{
         let onlineRef = Database.database().reference(withPath:"online/\(userId)")
        
        onlineRef.removeValue{(error, _) in
            
           if let error = error {
                print("Removing online user failed:\(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                 self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }catch(let error){
                print("Auth sign out failed: \(error)")
            }
        }
      }
        
   
        
}
    
    @IBAction func btnAddNotebook(_ sender: Any) {
        let alertController = UIAlertController(title: "New Notebook", message: "Enter New Notebook", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default){ _ in
            if let txtField = alertController.textFields?.first,
                let notebookName = txtField.text{
                print(notebookName)
               // let notebookItem = NotebookItem(name:text,
                //                                created at: )
                let user = Auth.auth().currentUser
                if let user = user {

                let notebookRef = Database.database().reference().child("Notebooks").child(user.uid)
                 notebookRef.childByAutoId().setValue([
                    "name": notebookName,
                    "created At":self.getTodayString()
                    ])
                
            }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Notebook Name"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
            
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebooksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotebooksCell", for: indexPath)
        
        noteBookName = notebooksList[indexPath.row].name
        let labelName = cell.viewWithTag(1) as! UILabel
        labelName.text = noteBookName
        let noteBookDate = notebooksList[indexPath.row].createdTime
        let labelDate = cell.viewWithTag(2) as! UILabel
        labelDate.text = noteBookDate

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       bookId = notebooksList[indexPath.row].bookId
      self.performSegue(withIdentifier: "NotebookToNotes", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100.0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotebookToNotes"{
            
            let notesVC = segue.destination as! NotesViewController
            notesVC.bookId = bookId
            // print(selectedApp!.description)
           
        }
    }
    
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


}
