//
//  PagerView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

import SwiftUI

struct PagerDotsView: View {
    let totalPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                RoundedRectangle(cornerRadius: index == currentPage ? 12 : 8)
                    .fill(index == currentPage ? Color.red : Color.gray.opacity(0.5))
                    .frame(width: index == currentPage ? 30 : 8, height: index == currentPage ? 12 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.vertical, 10)
    }
}

struct ContentView: View {
    @State private var currentPage = 0
    private let totalPages = 3
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Text("Page \(index + 1)")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(index % 2 == 0 ? Color.blue : Color.green)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots
            
            PagerDotsView(totalPages: totalPages, currentPage: currentPage)
        }
    }
}

#Preview{
    ContentView()
}
