//
//  CGFloat+Extension.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import Foundation
import UIKit

extension CGFloat {
    /**
     The relative dimension to the corresponding screen size.
     
     //Usage
     let someView = UIView(frame: CGRect(x: 0, y: 0, width: 375.dp, height: 40.dp)
     
     **Warning** Only works with size references from @1x mockups.
     
     */
    var dp: CGFloat {
        return (self / 375) * UIScreen.main.bounds.width //where 375 is your viewcontroller width where you are making desing
    }
    
    
    func max(_ value : CGFloat) -> CGFloat {
        if self > value {
            return value
        }
        return self
    }
}
