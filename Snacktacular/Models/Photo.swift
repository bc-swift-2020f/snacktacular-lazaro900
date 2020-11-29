//
//  Photo.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/15/20.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL": photoURL]
        
    }
    
    init (image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String) {
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
        
    }
    
    
    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "Unknown email"
        self.init (image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""

        
        self.init (image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
 
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        //convert photo to a data type
        
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("could not convert photo to data")
            return
        }
        
        //create metadata
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create a file name if necessary
        if documentID == "" {
            documentID = UUID().uuidString
            
        }
        
        //create a storage reference to upload
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        //create upload task
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metaData, error) in
            if let error = error {
                print("Error: upload for ref \(uploadMetaData) failed \(error.localizedDescription)")
            }
            
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("upload to storage was successfull")
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    print("Could not create a download url. \(error?.localizedDescription)")
                    return completion(false)
                }
                guard let url = url else {
                    print("url was nil. \(error?.localizedDescription)")
                    return completion(false)
                }
                self.photoURL = "\(url)"
                
                let dataToSave = self.dictionary
                
                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("Error updating document. \(error?.localizedDescription)")
                        return completion(false)
                    }
                    print("Document updated: \(self.documentID) in spot: \(spot.documentID)")
                    completion(true)
                }
                
            }
            
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("Error: upload task for file \(self.documentID) failed. \(error.localizedDescription)")
            }
            completion(false)
        }
    }
    
    func LoadImage(spot: Spot, completion: @escaping (Bool) -> ()) {
        guard spot.documentID != "" else {
            print("did not pass a valid spot into loadi mage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: an error occured while reading data from file ref \(storageRef    )")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    
    func deleteData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("photos").document(documentID).delete { (error) in
            if let error = error {
                print("error deleting photo documentID \(self.documentID)")
                completion(false)
            } else {
                self.deleteImage(spot: spot)
                print("successfully deleted review")
                
                    completion(true)
            }
        }
    }
    
    private func deleteImage(spot: Spot) {
        guard spot.documentID != "" else {
            print("error")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.delete {error in
            if let error = error {
                print("error. could not delete photo")
            } else {
                print("photo successfully deleted!")
            }
            
        }
    }
    
}
