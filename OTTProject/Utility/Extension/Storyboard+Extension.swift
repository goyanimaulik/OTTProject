//
//  Storyboard+Extension.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate(_ appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

enum AppStoryboard: String {
    
    case main = "Main"

    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardIdentifier
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as? T else {
            fatalError("ViewController with identifier \(storyboardId), not found")
        }
        return vc
    }
}
