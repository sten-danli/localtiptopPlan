//
//  HomeTableViewCell.swift
//  localtiptopPlan
//
//  Created by Dan Li on 23.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//didTapCommentImageView()

import UIKit
import Firebase

protocol HomeTableViewCellDelegate {
    func didTapCommentImageView(post: PostModel, user: User)
    func didTapContraCommentImageView(post: PostModel, user: User)
}

class HomeTableViewCell: UITableViewCell {
        let defaultHeight = 80
        let expectedHeight = 600
        var state: Bool = false
    
    var delegate: HomeTableViewCellDelegate?
    var user: User? {
        didSet{
            guard let profileImageurl = user?.profilimageUrl else{return}
            profilImageView.loadImage(with: profileImageurl)
            
            let userName = user?.username
            userNameLabel.text = userName
             layoutIfNeeded()
            
        }
    }
    var post: PostModel? {
        didSet{
            
            guard let postImageUrl = post?.imageUrl else{return}
            postImageView.loadImage(with: postImageUrl)
            
            let postText = post?.postText
            postTextLabel.text = postText
            
            if let ratio = post?.ratio {
                heightConstraint.constant = UIScreen.main.bounds.width / ratio
                           layoutIfNeeded()
            }
        }
    }

    // MARK: - Outlet
     
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintForTextLabel: NSLayoutConstraint!
    
    @IBAction func more(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
                      self.state = !self.state
                      self.heightConstraintForTextLabel.constant = CGFloat(self.state ? self.expectedHeight: self.defaultHeight)
//                      self.view.layoutIfNeeded()
              })
            }
    
    //👇按下留言图标时运行delegate里面的跳转页到CommenViewController
    func addGestureToimageView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCommentImageView))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleCommentImageView(){
        guard  let post = post else {return}
        guard  let user = user else {return}
        delegate?.didTapCommentImageView(post: post, user: user)
    }
    //👆按下留言图标时运行delegate里面的跳转页到CommenViewController
    
    //👇按下share图标时运行delegate里面的跳转页到CommenViewController
    func addGestureToContraimageView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContraCommentImageView))
        shareImageView.addGestureRecognizer(tapGesture)
        shareImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleContraCommentImageView(){
        guard  let post = post else {return}
        guard  let user = user else {return}
        delegate?.didTapContraCommentImageView(post: post, user: user)
    }
    //👆按下share图标时运行delegate里面的跳转页到CommenViewController
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilImageView.layer.cornerRadius = profilImageView.frame.width/2
        addGestureToimageView()
        addGestureToContraimageView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
    }
    
    override func prepareForReuse() {
        postImageView.image = UIImage(named: "placeholder")
    }

}
