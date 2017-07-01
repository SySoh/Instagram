//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Shao Yie Soh on 6/27/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var userNameHeaderLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var tableView: UITableView!
    var refreshTimer: Timer!
    
    var postList: [PFObject?] = []
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        
        let Login = storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(Login!, animated: true, completion: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated :true)
        }
        navigationController?.navigationBar.barTintColor = UIColor.gray
        tabBarController?.tabBar.barTintColor = UIColor.darkGray
        pullData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.borderColor = UIColor.black.cgColor
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
        pullData()
        let user = PFUser.current()
        if let creationDate = user?.createdAt{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let dateString = dateFormatter.string(from: creationDate)
                self.creationDateLabel.text = "User since: " + dateString// Prints: Jun 28, 2017, 2:08 PM
        }
        userNameHeaderLabel.text = PFUser.current()?.username
        if user?["profilePic"] != nil {
            profileImage.file = user?["profilePic"] as? PFFile
            self.profileImage.loadInBackground()
        }
        else{
            print("Something broke.")
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onProfilePicTap(_ sender: Any) {
        print("hello!")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Camera Available")
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Camera not available, so photo lib instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        profileImage.image = editedImage
        
        dismiss(animated: true, completion:{
            if let user = PFUser.current() {
        user["profilePic"] = Post.getPFFileFromImage(image: editedImage)
        user.saveInBackground()
            }
    
    
        })
    }
    
    
    func pullData(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.includeKey("createdAt")
        query.whereKey("author", equalTo: PFUser.current())
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
        self.refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = postList[indexPath.row]
        cell.setPost(post: post!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl){
        pullData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Detail" {
            print("sending")
            let destVC = segue.destination as! DetailViewController
            let source = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: source){
                if let thisPost = postList[indexPath.row] {
                    destVC.post = thisPost
                } else {
                    print("Empty post")
                }
            }
        }
        
        
        
    }
    
}
