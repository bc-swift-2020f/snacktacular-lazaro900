//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Lazaro Alvelaez on 11/14/20.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
