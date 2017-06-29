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
    
    var post: PFObject?

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.file = post?.object(forKey: "picture") as! PFFile
        self.photoView.loadInBackground()
        let user = post?.object(forKey:"author") as? PFUser
        if user?.username != nil {
            self.userLabel.text = user?.username
        } else{
            self.userLabel.text = "Anon"
        self.captionLabel.text = post?.object(forKey: "caption") as! String
        // Do any additional setup after loading the view.
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
