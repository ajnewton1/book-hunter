//
//  UploadViewController.swift
//  Book Hunter
//
//  Created by Aaron Newton on 2/21/17.
//  Copyright © 2017 Newt Inc. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // OUTLETS (Image View/ Buttons are created)
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorOfBookField: UITextField!
    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBAction func deletePostInfoBtn(_ sender: Any) {

        // Display alert message delete post.
        let myAlert = UIAlertController(title:"Remove Post", message:"If a Hunter happens to buy your book or you just want to remove it from our list, contact ajn54@pitt.edu and tell us what book you would like to remove.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default)
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
    }
    
    var picker = UIImagePickerController()
    
    // Do this before view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    // Function for picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectBtn.isHidden = true
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function for pressing the 'select' button
    @IBAction func selectPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        postBtn.isHidden = false
        self.present(picker, animated: true, completion: nil)
    }
    
    // Function for pressing the 'post' button
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://pitt-mobile-app-32a4b.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }

            // Get url for image and create post feed
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "email" : FIRAuth.auth()!.currentUser!.email!,
                                "title" : self.titleField.text!,
                                "Book Author" : self.authorOfBookField.text!,
                                "isbn" : self.isbnField.text!,
                                "price" : self.priceField.text!,
                                "postID" : key] as [String : Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        uploadTask.resume()
    }
}
