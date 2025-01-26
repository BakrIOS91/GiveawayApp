//
//  Array+Ext.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import Foundation

extension Array where Element: Identifiable {
    func updated(from newElements: [Element]) -> [Element] {
        var updatedArray = self
        for newElement in newElements {
            if let index = updatedArray.firstIndex(where: { $0.id == newElement.id }) {
                updatedArray[index] = newElement
            }
        }
        return updatedArray
    }
}
