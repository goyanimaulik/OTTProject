//
//  HomeViewModel.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import Foundation
import UIKit

class HomeViewModel {
    
    func fetchData(pageNo: Int, success: @escaping (PosterModel) -> Void, failure: ((String?) -> Void)? = nil) {
        if let path = Bundle.main.path(forResource: "CONTENTLISTINGPAGE-PAGE\(pageNo)", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let posterModel = try decoder.decode(PosterModel.self, from: data)
                success(posterModel)
            } catch {
                print("Error reading JSON file: \(error)")
                failure?(error.localizedDescription)
            }
        }
    }
}
