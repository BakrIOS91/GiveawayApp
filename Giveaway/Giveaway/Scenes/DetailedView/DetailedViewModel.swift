//
//  DetailedViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import Foundation
import Combine

final class DetailedViewModel: BaseViewModel<DetailedViewModel.State, DetailedViewModel.Action> {
    @Preference(\.favoriteGiveAways) var favoriteGiveAways
    
    let giveAwayClient: GiveAwayClient = .init()
    
    var didPressOnBackButtonSubject = PassthroughSubject<Void, Never>()
    
    struct State {
        var isLoading: Bool = false
        var apiError: APIError?
        
        var giveawayItemId: Int
        var isFavorite: Bool
        
        var giveawayItem: GiveAwayItem?
    }
    
    enum Action {
        case loadItemDetail
        case detailedItemResponse(Result<GiveAwayItem?, APIError>)
        case didPressOnFavorite
        case didPressOnBacButton
    }
    
    init(
        _ giveawayItemId: Int,
        isFavorite: Bool
    ) {
        super.init(
            state: .init(
                giveawayItemId: giveawayItemId,
                isFavorite: isFavorite
            )
        )
    }
    
    override func trigger(_ action: Action) {
        switch action {
        case .loadItemDetail:
            loadItemDetail()
        case .detailedItemResponse(let result):
            handelResponse(result)
        case .didPressOnFavorite:
            handelDidPressOnFavorite()
        case .didPressOnBacButton:
            didPressOnBackButtonSubject.send()
        }
    }
    
    fileprivate func loadItemDetail() {
        state.isLoading = true
        Task {
            await trigger(.detailedItemResponse(giveAwayClient.getGiveAwayDetail(state.giveawayItemId)))
        }
    }
    
    fileprivate func handelResponse(_ result: Result<GiveAwayItem?, APIError>) {
        state.isLoading = false
        switch result {
        case let .success(response):
            guard var response = response else {
                state.apiError = .noData
                return
            }
            response.isFavorite = state.isFavorite
            state.giveawayItem = response
        case let .failure(apiError):
            state.apiError = apiError
        }
    }
    
    
    fileprivate func handelDidPressOnFavorite() {
        if var favoriteItem = state.giveawayItem {
            favoriteItem.isFavorite = !(favoriteItem.isFavorite ?? false)
            state.giveawayItem = favoriteItem
            if favoriteItem.isFavorite == true {
                favoriteGiveAways.append(favoriteItem)
            } else {
                favoriteGiveAways.removeAll(where: { $0.id == favoriteItem.id})
            }
        }
    }
}
