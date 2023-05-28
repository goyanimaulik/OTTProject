//
//  MovieModel.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit

struct MovieModel: Codable {
    
    var page: Page?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
    }

    struct Page: Codable {
        
        var pageNum: String?
        var title: String?
        var pageSize: String?
        var totalContentItems: String?
        var contentItems: ContentItems?
        
        enum CodingKeys: String, CodingKey {
            case pageNum = "page-num"
            case title = "title"
            case pageSize = "page-size"
            case totalContentItems = "total-content-items"
            case contentItems = "content-items"
        }
    }
    
    struct ContentItems: Codable {
        
        var content: [Content]?
        
        enum CodingKeys: String, CodingKey {
            case content = "content"
        }
    }
    
    struct Content: Codable {
        
        var name: String?
        var posterImage: String?
        
        enum CodingKeys: String, CodingKey {
            case posterImage = "poster-image"
            case name = "name"
        }
    }
}
