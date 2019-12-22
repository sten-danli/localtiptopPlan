//
//  searchUserCell.swift
//  localtiptopPlan
//
//  Created by Dan Li on 11.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    // MARK: - Properties 属性

    var user: User? {
        didSet {
            guard let profileImageurl = user?.profilimageUrl else{return}
            let username = user?.username
            let email = user?.email
            
            profileImageView.loadImage(with: profileImageurl)
            self.textLabel!.text = username
            self.detailTextLabel!.text = email
        }
    }
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        //add profile image view
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.clipsToBounds = true
        
        textLabel?.text = "Username"
        detailTextLabel?.text = "Email"
    }
    
    //Subview的大小样式设定
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height:(textLabel?.frame.height)!)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: self.frame.width - 108, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = .lightGray
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
