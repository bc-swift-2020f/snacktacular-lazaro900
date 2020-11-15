//
//  PhotoViewController.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/14/20.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var savebarButton: UIBarButtonItem!
    
    var spot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else {
            print("Error not spot passed")
            return
        }

    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
   
    @IBAction func deleteButtonPressed(_ sender: Any) {
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    
}
