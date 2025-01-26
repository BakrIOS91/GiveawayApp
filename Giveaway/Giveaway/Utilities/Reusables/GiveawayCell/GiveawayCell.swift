//
//  GiveawayCell.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI
import Kingfisher

struct GiveawayCell: View {
    var giveAwayItem: GiveAwayItem
    var didPressOnFavorit: () -> Void
    var didPressOnItem: () -> Void
    
    init( giveAwayItem: GiveAwayItem,
          didPressOnItem: @escaping () -> Void = {},
          didPressOnFavorit: @escaping () -> Void = {}
    ) {
        self.giveAwayItem = giveAwayItem
        self.didPressOnItem = didPressOnItem
        self.didPressOnFavorit = didPressOnFavorit
    }
    
    var body: some View {
        ZStack {
            itemImageView
            
            ZStack(alignment: .topTrailing) {
                VStack {
                    titleView
                    
                    Spacer()
                    
                    descriptionView
                }
                .onTapGesture {
                    didPressOnItem()
                }
                
                Button {
                    didPressOnFavorit()
                } label: {
                    Image(systemName: (giveAwayItem.isFavorite ?? false) ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundStyle((giveAwayItem.isFavorite ?? false) ? .red : .white)
                        .frame(width: 25, height: 25)
                }
                
            }
            .padding()
            
        }
        .padding(.horizontal, 20)
        .frame(height: 300)
        
    }
    
    fileprivate var itemImageView: some View {
        KFImage(
            URL(string: giveAwayItem.image ?? "")
        )
        .placeholder {
            Image(.placeholder)
                .resizable()
        }
        .resizable()
        .frame(height: 300)
        .overlay {
            Color.black.opacity(0.8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.7), radius: 8)
    }
    
    fileprivate var titleView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(giveAwayItem.title ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(giveAwayItem.platforms ?? "")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.caption)
            }
            .padding(.trailing, 20)
            Spacer()
        }
        .foregroundStyle(.white)
    }
    
    fileprivate var descriptionView: some View {
        Text(giveAwayItem.description ?? "")
            .foregroundStyle(.white)
            .font(.subheadline)
    }
}

#Preview {
    GiveawayCell(
        giveAwayItem: .mock(1))
}
