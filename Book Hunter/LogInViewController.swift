//
//  LogInViewController.swift
//  Book Hunter
//
//  Created by Aaron Newton on 2/19/17.
//  Copyright © 2017 Newt Inc. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // OUTLETS (Text Fields are created)
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    // Before the user can see the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // function for the Log In button
    @IBAction func loginPressed(_ sender: Any) {
        
        // Check to see if user = user
        guard emailField.text != "", pwField.text != "" else {return}
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
            
            if let error = error {
                
                // Display an alert message
                self.displayMyAlertMessage(userMessage: "The email or password you entered in wrong")
                return
            }
            
            // Log on user/go to feed  if everything is good
            if let _ = user{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedVC")
                self.present(vc, animated: false, completion: nil)
            }
        })
    }
    
    // Function for the alert message
    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title:"Wrong Information", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
        
    }
}
