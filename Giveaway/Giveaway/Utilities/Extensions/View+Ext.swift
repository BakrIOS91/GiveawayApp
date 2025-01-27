//
//  View+Ext.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

extension View {
    /// Reads view size with geometry reader
    func readSize(
        onChange: @escaping (CGSize) -> Void
    ) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool, transform: (Self) -> Content,
        transformElse: ((Self) -> Content)? = nil) -> some View {
           if condition {
               transform(self)
           } else {
               if let transformElse = transformElse {
                   transformElse(self)
               } else {
                   self
               }
           }
       }
}
