//
//  PostCell.swift
//  Instagram
//
//  Created by Shao Yie Soh on 6/27/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var instagramPost: PFObject!{
            didSet{
            self.photoView.file = self.instagramPost.object(forKey: "picture") as? PFFile
            self.photoView.loadInBackground()
    }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
