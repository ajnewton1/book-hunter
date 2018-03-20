//
//  FeedViewController.swift
//  Book Hunter
//
//  Created by Aaron Newton on 2/21/17.
//  Copyright © 2017 Newt Inc. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // OUTLET (Collection View is created here)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func refreshFeedBtn(_ sender: Any) {
        fetchPosts()
    }
    
    var posts = [Post]()
    
    // Do this before view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }

    // Function to get the posts that every user posts
    func fetchPosts(){
        
        let ref = FIRDatabase.database().reference()
                        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in

            let postsSnap = snap.value as! [String : AnyObject]
            self.posts.removeAll()
            for (_,post) in postsSnap {
                
                if let userID = post["userID"] as? String {
                    let posst = Post()
                    if let email = post["email"] as? String, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let title = post["title"] as? String, let authorOfBook = post["Book Author"] as? String, let isbn = post["isbn"] as? String, let price = post["price"] as? String {
                        
                            posst.email = email
                            posst.pathToImage = pathToImage
                            posst.postID = postID
                            posst.userID = userID
                            posst.title = title
                            posst.authorOfBook = authorOfBook
                            posst.isbn = isbn
                            posst.price = price
                        
                            self.posts.append(posst)
                        }
                                            
                    self.collectionView.reloadData()
                }
            }
        })

        ref.removeAllObservers()
    }
    
    // Function fo number of sections in the Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Function for number of items in section in Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    // Function for putting the post into the Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        // Items needed for the post
        cell.postedImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.titleLabel.text = self.posts[indexPath.row].title
        cell.authorOfBook.text = self.posts[indexPath.row].authorOfBook
        cell.isbnLabel.text = self.posts[indexPath.row].isbn
        cell.postID = self.posts[indexPath.row].postID
        cell.emailLabel.text = self.posts[indexPath.row].email
        cell.priceLabel.text = self.posts[indexPath.row].price

        return cell
    }
}

// Image View
extension UIImageView {
    
    // Function to download the image
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}
