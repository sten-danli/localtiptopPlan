//
//  CommentTableViewCell.swift
//  localtiptopPlan
//
//  Created by Dan Li on 27.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!

    @IBOutlet weak var footerImage: UIImageView!//pacman
    
    // MARK: Setup View
    var comment: CommentModel?
//    var imagString:String? = ""
    
    var user: User? {
           didSet {
               
            guard let _commentText = comment?.commentText else { return }
            guard let _username = user?.username else { return }
            guard let _profilImageUrl = user?.profilimageUrl else { return }
            guard let _imagString = comment?.conproTag else { return }
            setupViewCell(commentText: _commentText, username: _username, profilImageUrl: _profilImageUrl, imagString: _imagString)
            
            
        }
       }
    func setupViewCell(commentText: String, username: String, profilImageUrl: String, imagString: String) {
        //👇在profilImag后面加入username。
        let attributedText = NSMutableAttributedString(string: username + "    ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imagString)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        attributedText.append(attachmentString)
        
        attributedText.append(NSMutableAttributedString(string: "\n" +  commentText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]))
        
        commentTextLabel.attributedText = attributedText
        profilImageView.loadImage(with: profilImageUrl)
        }
       //👇在profilImag后面加入username。
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilImageView.layer.cornerRadius = profilImageView.frame.width/2
        commentTextLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
