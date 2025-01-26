//
//  GiveAwayRequestModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

struct GiveAwayRequestModel: Codable, Equatable {
    let platform: String?
    let type: String?
    let sortBy: String?
    
    init(
        platform: String? = nil,
        type: String? = nil,
        sortBy: String? = nil
    ) {
        self.platform = platform
        self.type = type
        self.sortBy = sortBy
    }
    
    enum CodingKeys: String, CodingKey  {
        case platform, type
        case sortBy = "sort-by"
    }
}
