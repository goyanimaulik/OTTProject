//
//  MovieViewModel.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import Foundation
import UIKit

class MovieViewModel {
    
    func fetchData(pageNo: Int, success: @escaping (MovieModel) -> Void, failure: ((String?) -> Void)? = nil) {
        
        JsonManager.readFileFrom(fileName: "CONTENTLISTINGPAGE-PAGE\(pageNo)", model: MovieModel.self) { model in
            success(model)
        } failure: { error in
            failure?(error)
        }
    }
}
