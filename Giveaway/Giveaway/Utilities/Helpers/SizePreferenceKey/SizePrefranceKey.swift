//
//  SizePrefranceKey.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(
    value: inout CGSize,
    nextValue: () -> CGSize
  ) {}
}

