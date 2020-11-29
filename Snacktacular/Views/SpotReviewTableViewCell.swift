//
//  SpotReviewTableViewCell.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/8/20.
//

import UIKit

class SpotReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet var starImageConnection: [UIImageView]!
    
    var review: Review! {
        didSet {
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
            for starImage in starImageConnection {
                
                let imageName = (starImage.tag < review.rating ? "star.fill" : "star")
                starImage.image = UIImage(named: imageName)
                starImage.tintColor = (starImage.tag < review.rating ? .systemRed : .darkText)
                
            }
        }
    }
    
}
