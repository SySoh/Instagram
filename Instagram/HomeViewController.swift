//
//  HomeViewController.swift
//  Instagram
//
//  Created by Shao Yie Soh on 6/27/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshTimer: Timer!
    
    var postList: [PFObject?] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        pullData()
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pullData), userInfo: nil, repeats: true)
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    

    
    
    
    func pullData(){
        let query = PFQuery(className: "Post")
        //edit parameters for query here
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in if let error = error {
            print(error.localizedDescription)
        } else {
            if let posts = posts{
            self.postList = posts
            print(self.postList[0]?.object(forKey: "caption")! ?? "No caption")
            }
            else {
                print("Nil post retrieval")
            }
            }
        }
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = postList[indexPath.row]
        cell.instagramPost = post
        cell.captionLabel.text = post?.object(forKey: "caption") as! String
        let user = post?.object(forKey:"author") as? PFUser
//        if user?.username != nil {
//        cell.userLabel.text = user?.username
//        } else{
        cell.userLabel.text = "Anon"
      //  }
        cell.likesLabel.text = String(describing: post?.object(forKey: "likesCount") as! Int)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
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
