//
//  LookupFieldViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import Foundation

final class LookupFieldViewModel: BaseViewModel<LookupFieldViewModel.State, LookupFieldViewModel.Action> {
        
    struct State {
        var lookupType: LookupType
        var lookupItems: [LookupItem] = []
        var filteredLookupItems: [LookupItem] = []
        var selectedItems: [LookupItem] = []
        var showLookupList: Bool = false
        var isAllSelected: Bool {
            selectedItems.count == lookupItems.count
        }
        var searchText: String = ""
    }
    
    enum Action {
        case didPressOnShowLookup
        case didSelectLookupItem(LookupItem)
        case didPressOnSelectAll
        case onChangeSearchText(String)
    }
    
    init(lookupType: LookupType) {
        super.init(
            state: .init(
                lookupType: lookupType,
                lookupItems: lookupType.lookupItems
            )
        )
    }
    
    override func trigger(_ action: Action) {
        switch action {
        case .didPressOnShowLookup:
            state.showLookupList.toggle()
        case let.didSelectLookupItem(lookupItem):
            if state.selectedItems.contains(where: { $0.id == lookupItem.id}) {
                state.selectedItems.removeAll(where: {$0.id == lookupItem.id })
            } else {
                state.selectedItems.append(lookupItem)
            }
        case .didPressOnSelectAll:
            if state.isAllSelected {
                state.selectedItems.removeAll()
            } else {
                state.selectedItems = state.lookupItems
            }
        case let .onChangeSearchText(searchText):
            state.searchText = searchText
            if searchText.isEmpty {
                state.filteredLookupItems = state.lookupItems // Reset to full list
            } else {
                state.filteredLookupItems = state.lookupItems.filter { item in
                    item.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
}

