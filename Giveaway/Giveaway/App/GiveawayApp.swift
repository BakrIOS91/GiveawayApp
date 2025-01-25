//
//  GiveawayApp.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI

@main
struct GiveawayApp: App {
    var body: some Scene {
        WindowGroup {
            LookupFieldView(viewModel: .init(lookupType: .platform))
                .padding()
        }
    }
}
