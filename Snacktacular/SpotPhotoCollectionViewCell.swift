//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/15/20.
//

import UIKit
import SDWebImage

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var spot: Spot!
    
    var photo: Photo! {
        didSet {
            if let url = URL(string: self.photo.photoURL) {
                self.photoImageView.sd_setImage(with: url)
            } else {
                print("URL did not work.")
                self.photo.LoadImage(spot: self.spot) { (success) in
                    self.photo.saveData(spot: self.spot) { (success) in
                        print("image updated with url \(self.photo.photoURL)")
                    }
                }
            }
        }
    }
}
