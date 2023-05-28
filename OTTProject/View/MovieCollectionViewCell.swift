//
//  MovieCollectionViewCell.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieNameLbl: MarqueeLabel!
 
    func setupCell(data:PosterModel.Content) {
        movieImg.setImage(url: data.posterImage)
        movieNameLbl.text = data.name
        
        movieNameLbl.type = .continuous
        movieNameLbl.speed = .duration(10)
        movieNameLbl.animationCurve = .linear
        movieNameLbl.fadeLength = 10.0
        movieNameLbl.leadingBuffer = 0
        movieNameLbl.trailingBuffer = 40.0
    }

}


extension UIImageView {
    func setImage(url : String?) {
        if let url = url, let img = UIImage.init(named: url) {
            self.image = img
        } else {
            self.image = UIImage.init(named: "placeholder_for_missing_posters")
        }
    }
}
