//
//  UserProfileHeader.swift
//  localtiptopPlan
//
//  Created by Dan Li on 07.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    // MARK: -Properties
    
    var delegate: UserProfileHeaderDelegate?
    //属性观测器 //didset会在给变量user赋值后调用。当User内容有变动时，就用User内的内容，User是一个存储database内容的class。
    var user: User? {
        
        didSet{
            
            // configure wdit profils button
            configureEditProfileFollowButton()
            
            // set user stats
            
            let fullname = user?.username
            nameLabel.text = fullname
            
            guard let profilimageUrl = user?.profilimageUrl else {return}
            
            profileImageView.loadImage(with: profilimageUrl)
        }
    }

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let nameLabel: UILabel = {
          let label = UILabel()
          label.text = "Heath ledger"
          label.font = UIFont.boldSystemFont(ofSize: 12)
          return label
      }()
    
    let postLabel: UILabel = {
           let label = UILabel()
           label.numberOfLines = 0
           label.textAlignment = .center
           let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
           attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
           label.attributedText = attributedText
           return label
       }()
       
       let followersLabel: UILabel = {
           let label = UILabel()
           label.numberOfLines = 0
           label.textAlignment = .center
           let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
           attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
           label.attributedText = attributedText
           return label
       }()
       
       let followingLabel: UILabel = {
           let label = UILabel()
           label.numberOfLines = 0
           label.textAlignment = .center
           let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
           attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
           label.attributedText = attributedText
           return label
       }()
       
       let editProfileFollowButton : UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Loading", for: .normal)
           button.layer.cornerRadius = 3
           button.layer.borderColor = UIColor.lightGray.cgColor
           button.layer.borderWidth = 0.5
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
           button.setTitleColor(.black, for: .normal)
           return button
       }()
       
       let gridButton : UIButton = {
           let button = UIButton(type: .system)
           button.setImage(UIImage(systemName: "circle.grid.3x3.fill"), for: .normal)
           return button
       }()
       
       let listButton : UIButton = {
           let button = UIButton(type: .system)
           button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
           button.tintColor = UIColor(white: 0, alpha: 0.2)
           return button
       }()
       
       let bookmarkButton : UIButton = {
           let button = UIButton(type: .system)
           button.setImage(UIImage(systemName: "book"), for: .normal)
           button.tintColor = UIColor(white: 0, alpha: 0.2)
           return button
       }()
    

    // MARK: -Handler
    
    @objc func handleFollowersTapped(){
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped(){
        delegate?.handleFollowingTapped(for: self)
    }
    
    @objc func handleEditProfileFollow(){
        guard let user = self.user  else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Edit Profile"{
            print("Handle edit profile")
        }else{
            if editProfileFollowButton.titleLabel?.text == "Follow"{
                editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            }else{
                editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
        }
    }
    
     func setUserStats(for user: User?){
        delegate?.setUserStats(for : self)
    
    }
    

    override init(frame: CGRect) {
        super .init(frame: frame)
        //加入用户圆形照片view。
        addSubview(profileImageView)
        //加入照片在view上的地点。
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        configureUserStatus()
        
          addSubview(editProfileFollowButton)
         editProfileFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        configureBottomToolBar()
    }
        
    func configureBottomToolBar(){
    
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }

        func configureUserStatus(){
               let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
               stackView.axis = .horizontal
               stackView.distribution = .fillEqually
               
               self.addSubview(stackView)
               stackView.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }

    //如果user里的auth（）是当前current用户的话，那么editProfileFollowButtonj显示为Edit Profile，如果user里不是current用户的话那么editProfileFollowButton显示为Follow
    func configureEditProfileFollowButton() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        if currentUid == user.uid {
            
            // configure button as edit profile
            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            
        } else {
            
            // configure button as follow button
            editProfileFollowButton.setTitleColor(.white, for: .normal)
            editProfileFollowButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
