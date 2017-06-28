//
//  Post.swift
//  Instagram
//
//  Created by Shao Yie Soh on 6/27/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?){
    
    let post = PFObject(className: "Post")
    
        post["picture"] = getPFFileFromImage(image: image)
    post["author"] = PFUser.current()
        if let caption = caption {
    post["caption"] = caption
        }
        else {
            post["caption"] = ""
        }
    post["likesCount"] = 0
    post["commentsCount"] = 0
        
        
        post.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
              print(error.localizedDescription)
            } else {
            print ("Post successful!")
            }
        }
        
    }
    
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image){
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    

}


