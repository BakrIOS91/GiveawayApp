//
//  HomeView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            headerView
            
            SearchBarView(
                isFilterShown: true,
                placeholder: StringConstants.home_Search_Placeholder.text) { searchText in
                    viewModel.trigger(.handelSearchItems(searchText))
                } didPressOnFilterButton: {
                    
                }

            quickFilter
            
            giveawaysView()
        }
        .task {
            viewModel.trigger(
                .loadGiveAways(
                    viewModel.state.giveAwayRequestModel,
                    atPage: .first
                )
            )
        }
    }
    
    fileprivate var headerView: some View {
        HStack(alignment: .top) {
            // Leading Header
            VStack(alignment: .leading, spacing: 10) {
                Text("👋")
                
                Text(StringConstants.home_Greeting("Ffd"))
                    .fontWeight(.medium)
                
                Text(StringConstants.home_Title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // Trailing Header
            
            Image(.profileIcon)
                .resizable()
                .frame(width: 30, height: 30)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
    
    fileprivate var quickFilter: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                Button{
                    viewModel.trigger(
                        .loadGiveAways(
                            viewModel.state.giveAwayRequestModel,
                            atPage: .first
                        )
                    )
                } label: {
                    let isSelected = viewModel.state.quickFilterString.isEmpty
                    Text(StringConstants.home_Filter_All)
                        .fontWeight(isSelected ? .medium : .regular)
                        .foregroundStyle( (viewModel.state.quickFilterString.isEmpty) ? .black : Color.gray)
                }
                .buttonStyle(.plain)
                
                ForEach(
                    FilterPlatform.homeFilters.map({ LookupItem(name: $0.rawValue, value: $0.value) })
                ) { item in
                    let isSelected = viewModel.state.quickFilterString == item.value
                    Button{
                        viewModel.trigger(.handelQuickFilter(item.value))
                    } label: {
                        Text(item.value)
                            .fontWeight(isSelected ? .medium : .regular)
                            .foregroundStyle(isSelected ? .black : Color.gray)
                    }
                    .buttonStyle(.plain)
                }
                
                Button{
                    
                } label: {
                    Text(StringConstants.home_Filter_More)
                        .underline()
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    fileprivate func giveawaysView() -> some View {
        if viewModel.state.isLoading {
            LoaderView()
        } else {
            if let apiError = viewModel.state.apiError {
                ErrorView(
                    apiError: apiError) {
                        viewModel.trigger(
                            .loadGiveAways(
                                viewModel.state.giveAwayRequestModel,
                                atPage: .first
                            )
                        )
                    }
            } else {
                giveawaysListView
            }
        }
    }
    
    fileprivate var giveawaysListView: some View {
        List {
            ForEach(viewModel.state.searchText.isEmpty ? viewModel.state.paginatedItems : viewModel.state.filteredGiveawayItems) { item in
                GiveawayCell(
                    giveAwayItem: item
                ){
                    viewModel.trigger(.didSelectGiveawayItem(item))
                } didPressOnFavorit: {
                    viewModel.trigger(.didFavoriteGiveawayItem(item))
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            
            if viewModel.state.shouldPaginate {
                HStack {
                    Spacer()
                    
                    LoaderView()
                        .onAppear {
                            viewModel.trigger(.loadGiveAways(atPage: .next))
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.trigger(
                .loadGiveAways(
                    viewModel.state.giveAwayRequestModel,
                    atPage: .first
                )
            )
        }
    }
}

#Preview {
    HomeView(viewModel: .init())
}
