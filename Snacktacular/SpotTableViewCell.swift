//
//  SpotTableViewCell.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 10/31/20.
//

import UIKit
import CoreLocation

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!


    var currentLocation: CLLocation!
    
    var spot: Spot! {
        didSet {
            nameLabel.text = spot.name
            ratingLabel.text = "Avg. Rating: \(spot.averageRating)"
            
            guard let currentlocation = currentLocation else {
                distanceLabel.text = "Distance: -.-"
                return
            }
            let distanceInMeters = spot.location.distance(from: currentlocation)
            let distanceInMiles = ((distanceInMeters * 0.000621371) * 10).rounded() / 10
            distanceLabel.text = "Distance: \(distanceInMiles) miles"
        }
    }
}
