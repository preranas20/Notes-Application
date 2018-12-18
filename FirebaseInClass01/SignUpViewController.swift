//
//  SignUpViewController.swift
//  FirebaseInClass01
//
//  Created by Prerana Singh on 11/14/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/* File: SignupViewController.swift
 Assignment: InClass06
 Name: Prerana Singh
 */
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    @IBAction func submitBtn(_ sender: Any) {
        guard let txtEmail = email.text, let txtpassword = password.text,let txtUserName = username.text
            else {
                return
        }
        
        if(txtEmail == "" || txtpassword == "" || txtUserName == "" || confirmPassword.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if(txtpassword != self.confirmPassword.text){
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: txtEmail, password: txtpassword,
                               completion:{ (user, error) in
                                
                                if error != nil{
                                    let alertController = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                    return
                                }
                                    
                                    
                                    
                                else{
                                    
                                    guard let uid = user?.user.uid else{
                                        return
                                    }
                                    
                                    //successfully authenticated user
                                    let ref = Database.database().reference(fromURL: "https://iosinclass05.firebaseio.com/")
                                    let usersReference = ref.child("users").child(uid)
                                    let values = ["name":txtUserName,"email":txtEmail]
                                    usersReference.updateChildValues(values, withCompletionBlock:{ (err,ref) in
                                        
                                        if err != nil{
                                            let alertController = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                            
                                            alertController.addAction(defaultAction)
                                            self.present(alertController, animated: true, completion: nil)
                                            return
                                            
                                        }
                                        
                                        print("user saved successfully")
                                        self.performSegue(withIdentifier: "SignUpToNotebooks", sender: self)
                                        
                                        
                                    })
                                }
                                
        })
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
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
    
}

