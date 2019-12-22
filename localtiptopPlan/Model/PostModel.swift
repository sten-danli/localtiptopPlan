//
//  PostModel.swift
//  localtiptopPlan
//
//  Created by Dan Li on 24.11.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import Foundation

class PostModel {
    
    var postText: String?
    var imageUrl: String?
    var uid: String?
    var id: String?
    // Ratio
    var ratio: CGFloat?
    
   
    
    init(dictionary: Dictionary <String,AnyObject>, key: String){
        //    init(dictionary: [String: Any] ) {
        postText = dictionary["postText"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        uid = dictionary["uid"] as? String
        id = key
        
        // Ratio
        ratio = dictionary["imageRatio"] as? CGFloat
    }
}
