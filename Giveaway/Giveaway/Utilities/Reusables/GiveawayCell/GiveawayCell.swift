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
    var displayType: DisplayType
    var didPressOnFavorit: () -> Void
    var didPressOnItem: () -> Void
    
    enum DisplayType {
        case home
        case more
        case carousal
    }
    
    init( giveAwayItem: GiveAwayItem,
          displayType: DisplayType = .home,
          didPressOnItem: @escaping () -> Void = {},
          didPressOnFavorit: @escaping () -> Void = {}
    ) {
        self.giveAwayItem = giveAwayItem
        self.displayType = displayType
        self.didPressOnItem = didPressOnItem
        self.didPressOnFavorit = didPressOnFavorit
    }
    
    var body: some View {
        switch displayType {
        case .home:
            homeCelView
        case .more:
            moreCellView
        case .carousal:
            carousalCellView
        }
    }
    
    fileprivate var homeCelView: some View {
        ZStack {
            itemImageView
                .shadow(color: .black.opacity(0.7), radius: 8)

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
    
    fileprivate var moreCellView: some View {
        ZStack {
            itemImageView
            
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    Text(giveAwayItem.title ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
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
        .frame(width: 200, height: 200)
        .foregroundStyle(.white)
    }
    
    fileprivate var carousalCellView: some View {
        ZStack {
            itemImageView

            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    Text(giveAwayItem.title ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    descriptionView
                }
                .onTapGesture {
                    didPressOnItem()
                }
            }
            .padding()
        }
        .padding(.horizontal, 20)
        .frame(width: 350, height: 150)
        .foregroundStyle(.white)
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
        .overlay {
            Color.black.opacity(0.8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
            .foregroundStyle(.white.opacity(0.8))
            .font(.subheadline)
    }
}

#Preview {
    GiveawayCell(
        giveAwayItem: .mock(1), displayType: .more)
}
