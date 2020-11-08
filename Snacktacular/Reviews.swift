//
//  Reviews.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/8/20.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
}
