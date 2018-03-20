//
//  PostCell.swift
//  Book Hunter
//
//  Created by Aaron Newton on 2/21/17.
//  Copyright © 2017 Newt Inc. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UICollectionViewCell {
    
    // OUTLETS (Image View/Labels/Strings are created here)
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorOfBook: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var postID: String!
}
