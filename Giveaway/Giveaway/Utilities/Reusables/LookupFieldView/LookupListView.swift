//
//  LookupListView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI

struct LookupListView: View {
    @Bindable var viewModel: LookupFieldViewModel
    
    var body: some View {
        VStack {
            headerTitleView
            
            SearchBarView(isFilterShown: false) { searchText in
                viewModel.trigger(.onChangeSearchText(searchText))
            }
            
            if viewModel.state.searchText.isEmpty {
                headerSelectionView
            }
            
            listView
            
            actionView
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    
    fileprivate var headerTitleView: some View {
        Text(viewModel.state.lookupType.lookupTitle)
            .font(.title2)
            .padding(.vertical)
    }

    fileprivate var headerSelectionView: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.trigger(.didPressOnSelectAll)
            } label: {
                Text( viewModel.state.isAllSelected ? StringConstants.common_Deselect_All : StringConstants.common_Select_All)
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
    
    fileprivate var listView: some View {
        ScrollView {
            VStack {
                ForEach(
                    viewModel.state.searchText.isEmpty ? viewModel.state.lookupItems : viewModel.state.filteredLookupItems
                ) { lookupItem in
                    cellFor(lookupItem)
                }
            }
            .padding(.vertical)
        }
    }
    
    fileprivate func cellFor(_ lookupItem: LookupItem) -> some View {
        let itemSelected = viewModel.state.selectedItems.contains(where: { $0.id == lookupItem.id})
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(itemSelected ? Color.clear : Color.gray, lineWidth: 1)
                .fill(itemSelected ? .blue : .white)
                .frame(height: 60)
            
            HStack {
                Text(lookupItem.name)
                    .foregroundStyle(itemSelected ? .white : .black)
                Spacer()
                
                if itemSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
                    
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .onTapGesture {
            viewModel.trigger(.didSelectLookupItem(lookupItem))
        }
        
    }
    
    fileprivate var actionView: some View {
        Button {
            viewModel.trigger(.didPressOnShowLookup)
        } label: {
            HStack {
                Spacer()
                Text(StringConstants.common_Select)
                    .font(.title2)
                Spacer()
            }
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal, 30)
        .padding(.vertical)
    }
    
}


#Preview {
    LookupListView(viewModel: .init(lookupType: .platform))
}
