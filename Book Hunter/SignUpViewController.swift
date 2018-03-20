//
//  SignUpViewController.swift
//  Book Hunter
//
//  Created by Aaron Newton on 2/19/17.
//  Copyright © 2017 Newt Inc. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UINavigationControllerDelegate {

    // OUTLETS (Text Fields/ Image View/ Button are created)
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var comPwField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBAction func informationBtn(_ sender: Any) {
        
        // Display alert message for email.
        let myAlert = UIAlertController(title:"Email", message:"Your email is used for other Hunters to contact you so please enter a valid email address.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
        
    }
    
    @IBAction func infoButton(_ sender: Any) {
        
        // Display alert message for disclaimer.
        let myAlert = UIAlertController(title:"Disclaimer", message:"Book Hunter is not responsible for the distribution of books between users. It is up to the users to distribute the books and collect the payment.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
    }
    
    // Firebase
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    // Before the user can see the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = FIRStorage.storage().reference(forURL: "gs://pitt-mobile-app-32a4b.appspot.com")
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
        self.hideKeyboardWhenTappedAround()
    }
    
    // (ACTION) function for Next button
    @IBAction func nextPressed(_ sender: Any) {
        
        // Make sure all fields are filled
        guard nameField.text != "", emailField.text != "", password.text != "", comPwField.text != "" else { return}
        
        // Make sure passwords match
        if password.text == comPwField.text {
            
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: password.text!, completion: { (user, error) in
                if let error = error {
                    
                    // Display alert message
                    self.displayMyAlertMessage(userMessage: "Password must contain 6 characters and a number.")
                    return
                }
                
                // Make sure user = user
                if let user = user {
                    
                    // Display alert message with confirmation.
                    let myAlert = UIAlertController(title:"Welcome to Book Hunter", message:"Registration is successful. Thank you!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
                        self.dismiss(animated: true, completion:nil)
                    }
                    
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated:true, completion:nil)
                    
                    // Change request check
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                                                    // Dictionary filled with info
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "email" : self.emailField.text!,
                                                                ]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                // Switch to Users View Controller
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedVC")
                                self.present(vc, animated: false, completion: nil)
                            }
                        })
                }
            
        else {
            
            // Display an alert message
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return
        }
    }
    
    // Function for the alert message
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
    }
    
    // Function for the alert message
    func displayMyAlertMessage1(userMessage:String){
        
        let myAlert = UIAlertController(title:"Wrong Information", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
        
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
