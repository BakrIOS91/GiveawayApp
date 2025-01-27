//
//  LookupItem.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Foundation

struct LookupItem: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let value: String

    // Define equality based on `name` and `value`
    static func == (lhs: LookupItem, rhs: LookupItem) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}
