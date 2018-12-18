//
//  ViewController.swift
//  FirebaseInClass01
//
//  Created by Shehab, Mohamed on 11/9/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
/*Assignment : InClass05
 FileName : ViewController.swift
 Name: Prerana Singh
 */

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }


   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToSignUpSegue"{
 
        }
    }*/

    @IBAction func btnLogin(_ sender: Any) {
        guard let txtEmail = email.text , let txtPass = password.text
            else{
                return
        }

        
        if (txtEmail == "" || txtPass == ""){
            let alertController = UIAlertController(title: "Error", message: "Empty Fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: txtEmail, password: txtPass, completion: { (user, error) in
            
            
            if error != nil{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //successufully logged in our user
            self.performSegue(withIdentifier: "LoginToNotebooks", sender: self)
            
        })
        
        
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}

