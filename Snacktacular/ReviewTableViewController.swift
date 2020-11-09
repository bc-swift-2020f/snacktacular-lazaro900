//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/7/20.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var starButtionCollection: [UIButton]!
    
    var review: Review!
    var spot: Spot!
    var rating = 0 {
        didSet {
            for starButton in starButtionCollection {
                let imageName = (starButton.tag < rating ? "star.fill" : "star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < rating ? .systemRed : .darkText)
            }
            print(">> new rating: \(rating)")
            review.rating = rating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard spot != nil else {
            print("Error not spot passed")
            return
        }
        if review == nil {
            review = Review()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        reviewTitleLabel.text = review.title
        reviewTextView.text = review.text
        rating = review.rating
    }
    
    func updateFromUserInterface() {
        review.title = reviewTitleLabel.text!
        review.text = reviewTextView.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        review.saveData(spot: spot) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("Cant unwind from review")
            }
            
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    @IBAction func reviewTitleDonePressed(_ sender: UITextField) {
    }
    @IBAction func reviewTitleChanged(_ sender: UITextField) {
    }
    
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
    }
    
}
