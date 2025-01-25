//
//  GiveAwayRequestModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

struct GiveAwayRequestModel: Codable {
    let platform: String
    let type: String
    let sortBy: String
    
    enum CodingKeys: String, CodingKey  {
        case platform, type
        case sortBy = "sort-by"
    }
}
