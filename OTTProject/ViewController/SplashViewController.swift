//
//  SplashViewController.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit
import FLAnimatedImage

class SplashViewController: UIViewController {
    
    
    @IBOutlet weak var logoImg: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.playLogoAnimation()
    }
    
    func playLogoAnimation() {
        if let gifURL = Bundle.main.url(forResource: "splash_animation", withExtension: "gif") {
            if let gifData = try? Data(contentsOf: gifURL) {
                // Create an animated image from the GIF data
                if let animatedImage = FLAnimatedImage(animatedGIFData: gifData) {
                    
                    // Set the animated image to the image view
                    logoImg.animatedImage = animatedImage
                    
                    // Set the image view to play the animation once
                    logoImg.loopCompletionBlock = {_ in
                        self.logoImg.stopAnimating()
                        let homeVC = MovieListViewController.instantiate(.main)
                        self.navigationController?.pushViewController(homeVC, animated: false)
                    }

                    // Start the animation
                    logoImg.startAnimating()
                }
            }
        }

    }
}



