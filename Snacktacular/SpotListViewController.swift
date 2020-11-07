//
//  SpotListViewController.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 10/31/20.
//

import UIKit

class SpotListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    var spots: Spots!

    override func viewDidLoad() {
        super.viewDidLoad()
        spots = Spots()
        tableView.delegate = self
        tableView.dataSource = self
        configureSegmentControl()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidAppear(animated)
        spots.loadData {
            self.sortBasedOnSegmentPressed()
            self.tableView.reloadData()
        }
    }
    
    func configureSegmentControl() {
        let orangeFontColor = [NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor") ?? UIColor.orange]
        let whiteFontColor = [NSAttributedString.Key.foregroundColor : UIColor .white]

        
        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.setTitleTextAttributes(orangeFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(whiteFontColor, for: .normal)

        sortSegmentedControl.layer.borderWidth = 1.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! SpotDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.spot = spots.spotArray[selectedIndexPath.row]
        }
    }
    
    func sortBasedOnSegmentPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: //a-z
            spots.spotArray.sort(by: {$0.name < $1.name})
        case 1: // closest
            print("TODO")
        case 2: //average rating
            print("TODO")
        default:
            print("this should not happen")
        }
        tableView.reloadData()
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
    }
}

extension SpotListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.spotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpotTableViewCell
        cell.nameLabel?.text = spots.spotArray[indexPath.row].name
                return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}