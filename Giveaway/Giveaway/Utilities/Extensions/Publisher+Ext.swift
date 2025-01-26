//
//  Publisher+Ext.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Combine

extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        map { _ in }
    }
}
