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
 
    func setupCell(data:MovieModel.Content) {
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


