//
//  LocalizedStringKey.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

extension LocalizedStringKey {
    /// Converts a `LocalizedStringKey` to a `String` by resolving the localized value.
    var text: String {
        let mirror = Mirror(reflecting: self)
        guard let key = mirror.children.first(where: { $0.label == "key" })?.value as? String else {
            return ""
        }
        return NSLocalizedString(key, comment: "")
    }
}
