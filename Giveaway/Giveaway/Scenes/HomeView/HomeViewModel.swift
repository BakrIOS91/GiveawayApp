//
//  HomeViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import Foundation
import IdentifiedCollections

final class HomeViewModel: BaseViewModel<HomeViewModel.State, HomeViewModel.Action> {
    
    @Preference(\.favoriteGiveAways) var favoriteGiveAways
    let giveAwayClient: GiveAwayClient = GiveAwayClient()
    
    struct State {
        var isLoading: Bool = true
        var apiError: APIError?
        var giveAwayRequestModel: GiveAwayRequestModel?
        var pageIndex: Int = 0
        var giveawayItems: [[GiveAwayItem]] = []
        var paginatedItems: IdentifiedArrayOf<GiveAwayItem> = []
        var shouldPaginate: Bool = false
        var filteredGiveawayItems: IdentifiedArrayOf<GiveAwayItem> = []
        var searchText: String = ""
        var quickFilterString = ""
        
        // viewModels
    }
    enum Page {
        case first
        case next
    }
    
    enum Action {
        case loadGiveAways(GiveAwayRequestModel? = nil, atPage: Page)
        case giveawayesResponse(Result<[GiveAwayItem]?, APIError>)
        case didSelectGiveawayItem(GiveAwayItem)
        case didFavoriteGiveawayItem(GiveAwayItem)
        case handelSearchItems(String)
        case handelQuickFilter(String)
    }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(_ action: Action) {
        switch action {
        case let .loadGiveAways(giveAwayRequestModel, page):
            loadGiveawaysItems(giveAwayRequestModel, page)
        case let .giveawayesResponse(result):
            handelGiveawayRespone(result)
        case let .didSelectGiveawayItem(giveAwayItem):
            handelDidSelectGiveawayItem(giveAwayItem)
        case let .didFavoriteGiveawayItem(giveAwayItem):
            handelDidFavoriteGiveawayItem(giveAwayItem)
        case let .handelSearchItems(searchText):
            handelSearchItems(searchText)
        case let .handelQuickFilter(platform):
            state.quickFilterString = platform
            trigger(.loadGiveAways(.init(platform: platform), atPage: .first))
        }
    }
    
    fileprivate func loadGiveawaysItems(_ requestModel: GiveAwayRequestModel? = nil, _ atPage: Page) {
        if atPage == .first{
            state.isLoading = true
            if requestModel.isNil { state.quickFilterString = "" }
            Task {
                return await trigger(
                    .giveawayesResponse(
                        giveAwayClient.getGiveAways(requestModel)
                    )
                )
            }
        } else {
            handlePaginateGiveaways()
        }
    }
    
    fileprivate func handelGiveawayRespone(_ result: Result<[GiveAwayItem]?, APIError>) {
        state.isLoading = false
        switch result {
        case let .success(response):
            guard let items = response else {
                state.apiError = state.searchText.isEmpty ? .noData : .searchError
                return
            }
            
            let updatedGiveAwayItems = items.updated(from: favoriteGiveAways)
            
            // Divide response into chunks of 10 items each
            let chunkSize = 10
            state.giveawayItems = stride(from: 0, to: updatedGiveAwayItems.count, by: chunkSize).map {
                Array(updatedGiveAwayItems[$0..<min($0 + chunkSize, updatedGiveAwayItems.count)])
            }
            
            // Reset pagination
            state.pageIndex = 0
            state.paginatedItems.removeAll()
            state.paginatedItems.insert(contentsOf: state.giveawayItems[state.pageIndex], at: 0)
            
            state.shouldPaginate = !(state.paginatedItems.count == state.giveawayItems.flatMap { $0 }.count)
        case let .failure(apiError):
            state.apiError = apiError
        }
    }
    
    fileprivate func handlePaginateGiveaways() {
        state.pageIndex += 1
        state.paginatedItems.append(contentsOf: state.giveawayItems[state.pageIndex])
        state.shouldPaginate = !(state.paginatedItems.count == state.giveawayItems.flatMap { $0 }.count)
    }
    
    fileprivate func handelDidSelectGiveawayItem(_ item: GiveAwayItem)  {
        // should navigate to details View
    }
    
    fileprivate func handelDidFavoriteGiveawayItem(_ item: GiveAwayItem)  {
        var favoriteItem = item
        favoriteItem.isFavorite = !(favoriteItem.isFavorite ?? false)
        state.paginatedItems.updateOrInsert(favoriteItem, at: favoriteItem.id)
        if favoriteItem.isFavorite ?? false {
            favoriteGiveAways.append(favoriteItem)
        } else {
            favoriteGiveAways.removeAll(where: { $0.id == favoriteItem.id})
        }
    }
    
    fileprivate func handelSearchItems(_ searchText: String) {
        state.searchText = searchText
        state.shouldPaginate = false

        var allItems: IdentifiedArrayOf<GiveAwayItem> = []
        allItems.append(contentsOf:  state.giveawayItems.flatMap { $0 })
        
        if !searchText.isEmpty {
            state.filteredGiveawayItems = allItems.filter { item in
                // Safely unwrap the optional title and perform the search
                if let title = item.title {
                    return title.localizedCaseInsensitiveContains(searchText)
                } else {
                    // If the title is nil, exclude the item from the filtered results
                    return false
                }
            }
            
            // Set API error if no results are found
            state.apiError = state.filteredGiveawayItems.isEmpty ? .searchError : nil
        } else {
            // Clear filtered items and reset the error
            state.filteredGiveawayItems.removeAll()
            state.apiError = nil
        }
    }

}

