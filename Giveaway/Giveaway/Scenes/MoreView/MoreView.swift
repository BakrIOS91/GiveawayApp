//
//  MoreView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

import SwiftUI

struct MoreView: View {
    @Bindable var viewModel: MoreViewModel
    
    var body: some View {
        ZStack {
            if viewModel.state.isLoading {
                LoaderView()
            } else {
                if let apiError = viewModel.state.apiError {
                    ErrorView(apiError: apiError)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            crausalView
                            
                            ForEach(Array(viewModel.state.items.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                                if !value.isEmpty {
                                    sectionView(title: key, items: value)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.trigger(.loadGiveAways)
                    }
                }
            }
        }
        .task {
            viewModel.trigger(.loadGiveAways)
        }
        .navigationDestination(item: $viewModel.state.detailsViewModel) {
            DetailedView(viewModel: $0)
        }
    }
    
    fileprivate var crausalView: some View {
        VStack(alignment: .leading) {
            Text(StringConstants.categories)
                .font(.title)
                .fontWeight(.bold)
            
            TabView(selection: $viewModel.state.selectedPageIndex) {
                ForEach(Array(viewModel.state.carusalItems.enumerated()), id: \.element) { index, item in
                    GiveawayCell(
                        giveAwayItem: item,
                        displayType: .carousal) {
                            viewModel.trigger(.didSelectGiveawayItem(item))
                        } didPressOnFavorit: {
                            viewModel.trigger(.didFavoriteGiveawayItem(item))
                        }
                        .tag(index)
                }
            }
            .frame(height: 150)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack {
                Spacer()
                
                PagerDotsView(totalPages: viewModel.state.carusalItems.count, currentPage: viewModel.state.selectedPageIndex)
                
                Spacer()
            }
        }
    }
    
    fileprivate func sectionView(title: String, items: [GiveAwayItem]) -> some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        GiveawayCell(
                            giveAwayItem: item,
                            displayType: .more) {
                                viewModel.trigger(.didSelectGiveawayItem(item))
                            } didPressOnFavorit: {
                                viewModel.trigger(.didFavoriteGiveawayItem(item))
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    MoreView(viewModel: .init())
}
