//
//  ContraCommentModel.swift
//  localtiptopPlan
//
//  Created by Dan Li on 17.12.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import Foundation
class ContraCommentModel {
    
    var commentText: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        commentText = dictionary["contracommenttext"] as? String
        uid = dictionary["uid"] as? String
    }
}
