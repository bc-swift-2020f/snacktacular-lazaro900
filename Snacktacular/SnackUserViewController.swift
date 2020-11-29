//
//  SnackUserViewController.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/28/20.
//

import UIKit

class SnackUserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var snackUsers: SnackUsers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        snackUsers = SnackUsers()
        snackUsers.loadData {
            self.tableView.reloadData()
        }
    }
    


}

extension SnackUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackUsers.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SnackUserTableViewCell
        cell.snackUser = snackUsers.userArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
}
