//
//  Review.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/8/20.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["title": title, "text": text, "rating": rating, "reviewUserID": reviewUserID, "date": timeIntervalDate]
    }
    
    init(title: String, text: String, rating: Int, reviewUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(title: "", text: "", rating: 0, reviewUserID: "", date: Date(), documentID: "")
    }
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("Error adding document. \(error?.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Document added: \(self.documentID) to spot: \(spot.documentID)")
                completion(true)
            }
        } else {
            let ref = db.collection("spots").document(spot.documentID).collection("review").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("Error updating document. \(error?.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref.documentID
                print("Document updated: \(self.documentID) in spot: \(spot.documentID)")
                completion(true)
            }
        }
    }
}
