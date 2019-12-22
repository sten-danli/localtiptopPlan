//
//  User.swift
//  localtiptopPlan
//
//  Created by Dan Li on 07.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.

//User是一个存储database内容的class
import Firebase
import FirebaseDatabase

class User {
    var uid: String!
    var username: String!
    var activityTitle: String!
    var email: String!
    var profilimageUrl: String!
    var postsImageUrl : String!
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid

        //把dictionary里面“username”下的内容（是从database内得到的）赋值给让let username，然后再交给self var username。
        if let username = dictionary["username"] as? String{
            self.username = username
        }
        
        if let activityTitle = dictionary["postText"] as? String{
                   self.activityTitle = activityTitle
               }
        
        if let email = dictionary["email"] as? String{
            self.email = email
        }
        
        if let profilimageUrl = dictionary["profilImageUrl"] as? String{
            self.profilimageUrl = profilimageUrl
        }
        
        if let postsImageUrl = dictionary["imageUrl"] as? String{
                   self.postsImageUrl = postsImageUrl
               }
    }
//      Database.database().reference().child("users").child(currentUid)
     func follow() {
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
           
           // UPDATE: - get uid like this to work with update
           guard let uid = uid else { return }
           
           // set is followed to true
           self.isFollowed = true
           
           // add followed user to current user-following structure
           USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1])
           
           // add current user to followed user-follower structure
           USER_FOLLOWER_REF.child(uid).updateChildValues([currentUid: 1])
        
           // add followed users posts to current user-feed
           USER_POSTS_REF.child(uid).observe(.childAdded) { (snapshot) in
               let postId = snapshot.key
               USER_FEED_REF.child(currentUid).updateChildValues([postId: 1])
           }
       }
       
       func unfollow() {
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
           
           // UPDATE: - get uid like this to work with update
           guard let uid = uid else { return }
           
           self.isFollowed = false

           USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
           
           USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue()
           
           USER_POSTS_REF.child(uid).observe(.childAdded) { (snapshot) in
               let postId = snapshot.key
               USER_FEED_REF.child(currentUid).child(postId).removeValue()
           }
       }
    
    func checkIfUserIsFollowed(){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        USER_FOLLOWING_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(self.uid) {
                self.isFollowed = true
                print("user is followed")
            } else {
                self.isFollowed = false
                print("user is unfollowed")
            }
        }
    }
}

