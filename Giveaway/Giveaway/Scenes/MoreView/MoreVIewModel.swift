//
//  MoreViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

final class MoreViewModel: BaseViewModel<MoreViewModel.State, MoreViewModel.Action> {
    @Preference(\.favoriteGiveAways) var favoriteGiveAways
    
    let giveAwayClient: GiveAwayClient = .init()
    
    struct State {
        var isLoading: Bool = false
        var apiError: APIError?
        var selectedPageIndex: Int = 0
        var carusalItems: [GiveAwayItem] = []
        var items: [String: [GiveAwayItem]] = [:]
        
        // viewModels
        var detailsViewModel: DetailedViewModel?
    }
    
    enum Action {
        case loadGiveAways
        case giveawayesResponse(Result<[GiveAwayItem]?, APIError>)
        case didSelectGiveawayItem(GiveAwayItem)
        case didFavoriteGiveawayItem(GiveAwayItem)
    }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(_ action: Action) {
        switch action {
        case .loadGiveAways:
            loadGiveawaysItems()
        case .giveawayesResponse(let result):
            handelGiveawayRespone(result)
        case .didSelectGiveawayItem(let giveAwayItem):
            handelDidSelectGiveawayItem(giveAwayItem)
        case .didFavoriteGiveawayItem(let giveAwayItem):
            handelDidFavoriteGiveawayItem(giveAwayItem)
        }
    }
    
    fileprivate func loadGiveawaysItems() {
        state.isLoading = true
        Task {
            return await trigger(
                .giveawayesResponse(
                    giveAwayClient.getGiveAways(.init(platform: FilterPlatform.availableInMore.map({$0.value}).joined(separator: ".")))
                )
            )
        }
    }
    
    fileprivate func handelGiveawayRespone(_ result: Result<[GiveAwayItem]?, APIError>) {
        state.isLoading = false
        switch result {
        case let .success(response):
            guard let items = response else {
                state.apiError = .noData
                return
            }
            let updatedItems = items.updated(from: favoriteGiveAways)
            
            state.carusalItems = Array(updatedItems.prefix(5))
            
            var filteredItems: [String: [GiveAwayItem]] = [:]
            for platform in FilterPlatform.availableInMore {
                filteredItems[platform.rawValue] = updatedItems.filter { $0.platforms?.contains(platform.rawValue) ?? false }
            }
            
            state.items = filteredItems
            
        case let .failure(apiError):
            state.apiError = apiError
        }
    }
    
    fileprivate func handelDidSelectGiveawayItem(_ item: GiveAwayItem)  {
        state.detailsViewModel = createDetailViewModel(item.id, item.isFavorite ?? false)
    }
    
    fileprivate func handelDidFavoriteGiveawayItem(_ item: GiveAwayItem)  {
        var favoriteItem = item
        favoriteItem.isFavorite = !(favoriteItem.isFavorite ?? false)
        
        // Update the section's items
        state.items.forEach { key, items in
            state.items[key] = items.map {
                $0.id == favoriteItem.id ? favoriteItem : $0
            }
        }
        
        if favoriteItem.isFavorite ?? false {
            favoriteGiveAways.append(favoriteItem)
        } else {
            favoriteGiveAways.removeAll(where: { $0.id == favoriteItem.id})
        }
    }
    
    fileprivate func createDetailViewModel(_ itemId: Int, _ isFavorite: Bool) -> DetailedViewModel {
        let detailViewModel = DetailedViewModel(itemId, isFavorite: isFavorite)
        detailViewModel.didPressOnBackButtonSubject
            .sink { [weak self] in
                guard let self else { return }
                state.detailsViewModel = nil
            }
            .store(in: &cancelables)
        
        return detailViewModel
    }
    
}
