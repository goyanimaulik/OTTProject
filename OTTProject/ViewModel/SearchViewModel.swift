//
//  SearchViewModel.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import Foundation
import UIKit

class SearchViewModel {
    
    func fetchMostPopularMovie(success: @escaping (PosterModel) -> Void, failure: ((String?) -> Void)? = nil) {
        
        JsonManager.readFileFrom(fileName: "MOST-POPULAR", model: PosterModel.self) { model in
            success(model)
        } failure: { error in
            failure?(error)
        }
    }
}
