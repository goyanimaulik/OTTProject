//
//  SearchViewModel.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import Foundation
import UIKit

class SearchViewModel {
    
    func fetchMostPopularMovie(success: @escaping (MovieModel) -> Void, failure: ((String?) -> Void)? = nil) {
        
        JsonManager.readFileFrom(fileName: "MOST-POPULAR", model: MovieModel.self) { model in
            success(model)
        } failure: { error in
            failure?(error)
        }
    }
}
