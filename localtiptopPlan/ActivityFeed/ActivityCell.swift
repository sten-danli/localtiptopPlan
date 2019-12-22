//
//  ActivityCell.swift
//  localtiptopPlan
//
//  Created by Dan Li on 11.12.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//


import UIKit


class ActivityCell: UICollectionViewCell {
    
    var user: User? {
        didSet{
//            guard let profileImageurl = user?.profilimageUrl else{return}
//            imageView.loadImage(with: profileImageurl)
        }
    }
    var post: PostModel? {
        didSet{
            guard let postImageUrl = post?.imageUrl else{return}
            imageView.loadImage(with: postImageUrl)
        }
    }

//    var image:UIImage!{
//        didSet {
//            imageView.image = image
//        }
//    }
    
        let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.frame = contentView.frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


