//
//  LookupItem.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Foundation

struct LookupItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
