//
//  User.swift
//  MyFavoriteApp25
//
//  Created by Hannah Hoff on 3/20/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let name: String
    let favoriteApp: String
    
    enum CodingKeys: String, CodingKey{
        case name
        case favoriteApp = "favApp"
    }
}
