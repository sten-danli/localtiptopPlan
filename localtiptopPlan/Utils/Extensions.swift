//
//  Extensions.swift
//  localtiptopPlan
//
//  Created by Dan Li on 07.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//


import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,width: CGFloat, height: CGFloat ){
        
        translatesAutoresizingMaskIntoConstraints = false //将自动调整大小的蒙版转换为约束 = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

var imageCache = [String: UIImage]()
// 在UIImage下面加入一个从database内图片urlString读出并解析的功能。
extension UIImageView {//在UIImageView中曾加一个loadImage功能，这样所有属于UIImageView属性的方法都可以调用这个功能。
    
    func loadImage(with urlString: String) {
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        guard let url = URL(string:urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if let error = error{
                print("Faild to load image with error", error.localizedDescription)
            }
            guard let imageData = data else{return}
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}

extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = true)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)

            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)

            self.attributedText = mutableAttachmentString
        }
    }

    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

