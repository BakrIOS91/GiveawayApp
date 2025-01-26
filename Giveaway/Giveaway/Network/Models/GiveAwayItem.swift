//
//  GiveAwayItem.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Foundation

// MARK: - GiveAwayItem
struct GiveAwayItem: Codable,Identifiable, Hashable {
    let id: Int
    let title, worth: String?
    let thumbnail, image: String?
    let description, instructions: String?
    let openGiveawayURL: String?
    let publishedDate, type, platforms, endDate: String?
    let users: Int?
    let status: String?
    let gamerpowerURL, openGiveaway: String?
    
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, worth, thumbnail, image, description, instructions
        case openGiveawayURL = "open_giveaway_url"
        case publishedDate = "published_date"
        case type, platforms
        case endDate = "end_date"
        case users, status
        case gamerpowerURL = "gamerpower_url"
        case openGiveaway = "open_giveaway"
        case isFavorite
    }
    
    static func mock(_ id: Int) -> GiveAwayItem {
        return GiveAwayItem(
            id: id,
            title: "HUMANKIND - Cultures of Latin America Pack (Steam) Giveaway",
            worth: "$8.99",
            thumbnail: "https://www.gamerpower.com/offers/1/6792f42873621.jpg",
            image: "https://www.gamerpower.com/offers/1b/6792f42873621.jpg",
            description: "Claim your free HUMANKIND - Cultures of Latin America Pack (DLC) via Steam! Each pack includes 6 new cultures, 6 new wonders and much more!",
            instructions: "1. Click the button to visit the giveaway page.\r\n2. Download this pack directly via Steam before expires.\r\n3. Please note the base game via Steam is required to enjoy this content.",
            openGiveawayURL: "https://www.gamerpower.com/open/humankind-cultures-of-latin-america-pack-steam-giveaway",
            publishedDate: "2025-01-23 21:00:08",
            type: "DLC",
            platforms: "PC, Steam",
            endDate: "2025-01-30 23:59:00",
            users: 360,
            status: "Active",
            gamerpowerURL: "https://www.gamerpower.com/humankind-cultures-of-latin-america-pack-steam-giveaway",
            openGiveaway: "https://www.gamerpower.com/open/humankind-cultures-of-latin-america-pack-steam-giveaway"
        )
    }
    
    static func mockArray(count: Int) -> [GiveAwayItem] {
        return (1...count).map { mock($0) }
    }
}
