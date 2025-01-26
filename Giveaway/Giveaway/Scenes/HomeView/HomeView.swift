//
//  HomeView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            headerView
            
            SearchBarView(
                isFilterShown: true,
                placeholder: StringConstants.home_Search_Placeholder.text) { searchText in
                    
                } didPressOnFilterButton: {
                    
                }

            quickFilter
            
            giveawaysListView
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
                    
                } label: {
                    Text(StringConstants.home_Filter_All)
                        .fontWeight(.medium)
                }
                .buttonStyle(.plain)
                
                ForEach(FilterPlatform.homeFilters.map({ LookupItem(name: $0.rawValue, value: $0.value) })) { item in
                    
                    Button{
                        
                    } label: {
                        Text(item.value)
                            .foregroundStyle(Color.gray)
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
    
    fileprivate var giveawaysListView: some View {
        ScrollView {
            Image(.profileIcon)
                .redacted(reason: .placeholder)
        }
    }
}

#Preview {
    HomeView()
}
