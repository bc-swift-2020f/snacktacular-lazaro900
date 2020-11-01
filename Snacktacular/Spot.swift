//
//  Spot.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 10/31/20.
//

import Foundation
import Firebase
import MapKit

class Spot: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Double
    var postingUsertID: String
    var documentID: String
    
    
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "latitude": latitude, "longitude": longititude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUsertID": postingUsertID]
    
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longititude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
    init(name: String,address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Double, postingUsertID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUsertID = postingUsertID
        self.documentID = documentID
        
    }
    
    override convenience init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0.0, postingUsertID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Double? ?? 0.0
        let postingUsertID = dictionary["postingUsertID"] as! String? ?? ""

        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUsertID: postingUsertID, documentID: "")

    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("no valid postingUserID")
            return completion(false)
        }
        
        self.postingUsertID = postingUserID
        
        let dataToSave: [String: Any] = self.dictionary
        
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave){ (error) in
                guard error == nil else {
                    print("Error adding document. \(error?.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Document added: \(self.documentID)")
                completion(true)
            }
        } else {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("Error updating document. \(error?.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref.documentID
                print("Document updated: \(self.documentID)")
                completion(true)
            }
        }
    }
}
