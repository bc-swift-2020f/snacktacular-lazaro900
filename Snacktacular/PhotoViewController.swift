//
//  PhotoViewController.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/14/20.
//

import UIKit
import Firebase
import SDWebImage

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
} ()


class PhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var savebarButton: UIBarButtonItem!
    
    var spot: Spot!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else {
            print("Error not spot passed")
            return
        }
        
        if photo == nil {
            photo = Photo()
        }
        
        updateUserInterface()

    }
    
    func updateUserInterface() {
        postedByLabel.text = "by: \(photo.photoUserEmail)"
        dateLabel.text = "on: \(dateFormatter.string(from: photo.date))"
        descriptionTextView.text = photo.description
        photoImageView.image = photo.image
        
        if photo.documentID == "" {
            addBordersToEditableObjects()
        } else {
            if photo.photoUserID == Auth.auth().currentUser?.uid {
                self.navigationItem.leftItemsSupplementBackButton = false
                savebarButton.title = "Update"
                addBordersToEditableObjects()
                self.navigationController?.setToolbarHidden(false, animated: true)
            } else {
                savebarButton.hide()
                cancelBarButton.hide()
                postedByLabel.text = "Posted by: \(photo.photoUserEmail)"
                descriptionTextView.isEditable = false
                descriptionTextView.backgroundColor = .white
            }
        }
        guard let url = URL(string: photo.photoURL) else {
            //then this must be a new image.
            photoImageView.image = photo.image
            return
        }
        photoImageView.sd_setImage(with: url)
        
    }
    
    func addBordersToEditableObjects() {
        descriptionTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateFromUserInterface() {
        photo.description = descriptionTextView.text!
        photo.image = photoImageView.image!
    }
   
    @IBAction func deleteButtonPressed(_ sender: Any) {
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateFromUserInterface()
        photo.saveData(spot: spot) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("Cant unwind from review")
            }
            
        }
    }
    
}
