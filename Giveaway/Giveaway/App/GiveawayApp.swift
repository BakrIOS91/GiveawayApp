//
//  GiveawayApp.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI

@main
struct GiveawayApp: App {
    
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: .init())
        }
    }
}
