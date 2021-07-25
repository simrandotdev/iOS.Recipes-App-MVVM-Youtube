//
//  Recipe.swift
//  Recipes App
//
//  Created by jc on 2021-07-03.
//

import Foundation

struct Recipe: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let socialScore: Double
    let publisher: String
    let publishedId: String
    
    enum CodingKeys: String, CodingKey {
        case socialScore = "socialUrl"
        case id
        case title
        case imageUrl
        case publisher
        case publishedId
    }
}
