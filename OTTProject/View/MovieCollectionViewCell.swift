//
//  MovieCollectionViewCell.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var posterNameLbl: UILabel!
 
    func setupCell(data:PosterModel.Content) {
        posterImg.setImage(url: data.posterImage)
        posterNameLbl.text = data.name
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
