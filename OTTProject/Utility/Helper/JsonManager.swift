//
//  JsonManager.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import Foundation

class JsonManager: NSObject {
    static var shared = JsonManager()
    
    class func readFileFrom<T>(fileName: String, model: T.Type, success: @escaping (T) -> Void, failure: ((String?) -> Void)? = nil) where T: Codable {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(model, from: data)
                success(model)
            } catch {
                print("Error reading JSON file: \(error)")
                failure?(error.localizedDescription)
            }
        } else {
            failure?("File not found")
        }

    }
}
