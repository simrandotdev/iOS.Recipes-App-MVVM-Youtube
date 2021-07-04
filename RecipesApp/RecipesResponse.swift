//
//  RecipesResponse.swift
//  Recipes App
//
//  Created by jc on 2021-07-03.
//

import Foundation

struct RecipesResponse: Codable {
    let count: Int
    let recipes: [Recipe]
}
