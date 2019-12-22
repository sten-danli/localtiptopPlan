//
//  UserProfileVC.swift
//  localtiptopPlan
//
//  Created by Dan Li on 07.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"


class UserProfileVC: UICollectionViewController,UICollectionViewDelegateFlowLayout,UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader) {
        
    }
    
    func setUserStats(for header: UserProfileHeader) {
        
    }
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
       
    }
    

    var currentUser : User?
    var userToloadFromSearchVC: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // background color
        self.collectionView.backgroundColor = .white
        
        // fetch user data
        if userToloadFromSearchVC == nil {
        fetchCurrentUserData()
        
        }
    }

    // MARK: UICollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: view.frame.width, height: 200)
       }

    
    override func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView{
            
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        header.delegate = self
        // set the user in header
        if let user = self.currentUser {
            header.user = user
        }else if let userToloadFromSearchVC = self.userToloadFromSearchVC {
            header.user = userToloadFromSearchVC
            navigationItem.title = userToloadFromSearchVC.username
        }
        return header
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

     //MARK: -API   //观察（observe）database内usere的内容并存到snapshot内交给dictionary//得到Firebase databasen存储内容
       func fetchCurrentUserData(){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else {return}
            let uid = snapshot.key//和currentUid是一样的
            let user = User(uid: uid, dictionary: dictionary)
            self.currentUser = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        
       }
    
    }
}
