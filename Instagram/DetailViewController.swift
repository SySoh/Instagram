//
//  DetailViewController.swift
//  Instagram
//
//  Created by Shao Yie Soh on 6/28/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    var post: PFObject!

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var profilePhoto: PFImageView!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoView.file = post?.object(forKey: "picture") as? PFFile
        self.photoView.loadInBackground()
        self.captionLabel.text = post.object(forKey: "caption") as? String ?? "No caption"
        if let date = post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            self.timeStampLabel.text = dateString// Prints: Jun 28, 2017, 2:08 PM
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.gray
        tabBarController?.tabBar.barTintColor = UIColor.darkGray
        if let user = post.object(forKey:"author") as? PFUser{
            self.profilePhoto.file = user["profilePic"] as? PFFile
            self.profilePhoto.loadInBackground()
            self.profilePhoto.layer.cornerRadius = 37
            self.profilePhoto.clipsToBounds = true

        if user.username != nil {
            self.userLabel.text = user.username
        }
        }else{
            self.userLabel.text = "Anon"
    }
}
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
