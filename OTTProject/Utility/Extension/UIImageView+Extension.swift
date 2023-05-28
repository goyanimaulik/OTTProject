//
//  UIImageView+Extension.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url : String?) {
        if let url = url, let img = UIImage.init(named: url) {
            self.image = img
        } else {
            self.image = UIImage.init(named: "placeholder_for_missing_posters")
        }
    }
}
