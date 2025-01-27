//
//  HomeViewModelTests.swift
//  Giveaway
//
//  Created by Bakr Mohamed on 26/01/2025.
//

import XCTest
@testable import Giveaway
import IdentifiedCollections

@MainActor
final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testLoadGiveAways_FirstPage_ShouldSetLoadingState() {
        // Given
        let requestModel = GiveAwayRequestModel()

        // When
        viewModel.trigger(.loadGiveAways(requestModel, atPage: .first))

        // Then
        XCTAssertTrue(viewModel.state.isLoading, "The loading state should be true when loading giveaways.")
    }

    func testGiveawayesResponse_Success_ShouldPopulateItems() {
        // Given
        let items = GiveAwayItem.mockArray(count: 3)
        let result: Result<[GiveAwayItem]?, APIError> = .success(items)

        // When
        viewModel.trigger(.giveawayesResponse(result))

        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving a response.")
        XCTAssertEqual(viewModel.state.paginatedItems.count, 3, "The paginated items count should match the response count.")
    }

    func testGiveawayesResponse_Failure_ShouldSetAPIError() {
        // Given
        let error = APIError.noData
        let result: Result<[GiveAwayItem]?, APIError> = .failure(error)

        // When
        viewModel.trigger(.giveawayesResponse(result))

        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving an error.")
        XCTAssertEqual(viewModel.state.apiError, error, "APIError should be set correctly on failure.")
    }

    func testGiveawayesResponse_NoData_ShouldSetNoDataError() {
        // Given
        let result: Result<[GiveAwayItem]?, APIError> = .success(nil)

        // When
        viewModel.trigger(.giveawayesResponse(result))

        // Then
        XCTAssertTrue(viewModel.state.apiError == .noData, "APIError should be noData when response is nil.")
    }

    func testLoadGiveAways_SecondPage_ShouldNotSetLoadingState() {
        // Given
        let items = GiveAwayItem.mockArray(count: 25)
        viewModel.state.giveawayItems = [items]
        // When
        viewModel.trigger(.giveawayesResponse(.success(items)))
        viewModel.trigger(.loadGiveAways(nil, atPage: .next))

        // Then
        XCTAssertFalse(viewModel.state.isLoading, "The loading state should not be set when loading the second page.")
    }

    func testDidSelectGiveawayItem_ShouldHandleSelectionWithoutError() {
        // Given
        let item = GiveAwayItem.mock(1)

        // When
        viewModel.trigger(.didSelectGiveawayItem(item))

        // Then
        XCTAssertNotNil(viewModel.state.detailsViewModel, "DetailsViewModel should not be nil after selecting an item.")
    }

    func testDidFavoriteGiveawayItem_ToggleFavoriteState_ShouldUpdateCorrectly() {
        // Given
        var item = GiveAwayItem.mock(1)
        item.isFavorite = false
        viewModel.state.paginatedItems.insert(item, at: 0)
        
        // When: Toggle favorite state
        viewModel.trigger(.didFavoriteGiveawayItem(item))

        // Then: Check if the favorite state is toggled
        XCTAssertTrue(viewModel.state.paginatedItems.first(where: { $0.id == item.id})?.isFavorite == true, "The item's favorite state should toggle to true.")

        // When: Toggle favorite state back
        item.isFavorite = true
        viewModel.trigger(.didFavoriteGiveawayItem(item))

        // Then: Check if the favorite state is toggled back
        XCTAssertTrue(viewModel.state.paginatedItems.first(where: { $0.id == item.id})?.isFavorite == false, "The item's favorite state should toggle back to false.")
    }

    func testHandelSearchItems_ValidSearchText_ShouldFilterItems() {
        // Given
        viewModel.state.giveawayItems = [GiveAwayItem.mockArray(count: 5)]
        let searchText = "Latin America"

        // When
        viewModel.trigger(.handelSearchItems(searchText))

        // Then
        XCTAssertEqual(viewModel.state.filteredGiveawayItems.count, 5, "Filtered items count should match the search result.")
        XCTAssertEqual(viewModel.state.filteredGiveawayItems.first?.title, "HUMANKIND - Cultures of Latin America Pack (Steam) Giveaway", "Filtered item title should match the search text.")
    }

    func testHandelSearchItems_EmptySearchText_ShouldClearFilteredItems() {
        // Given
        viewModel.state.filteredGiveawayItems = IdentifiedArrayOf(uniqueElements: [GiveAwayItem.mock(1)])

        // When
        viewModel.trigger(.handelSearchItems(""))

        // Then
        XCTAssertTrue(viewModel.state.filteredGiveawayItems.isEmpty, "Filtered items should be cleared when search text is empty.")
    }

    func testHandelSearchItems_NoMatchingItems_ShouldSetSearchError() {
        // Given
        viewModel.state.giveawayItems = [GiveAwayItem.mockArray(count: 5)]
        let searchText = "No Match"

        // When
        viewModel.trigger(.handelSearchItems(searchText))

        // Then
        XCTAssertTrue(viewModel.state.filteredGiveawayItems.isEmpty, "No items should match the search text.")
        XCTAssertEqual(viewModel.state.apiError, .searchError, "APIError should be set to searchError when no matching items are found.")
    }

    func testDidPressOnGiveawayItem_InitializeDetailsViewModel_ShouldNotBeNil() {
        // Given
        let item = GiveAwayItem.mock(1)

        // When
        viewModel.trigger(.didSelectGiveawayItem(item))

        // Then
        XCTAssertNotNil(viewModel.state.detailsViewModel, "DetailsViewModel should not be nil after selecting an item.")
    }

    func testHandelQuickFilter_ShouldTriggerLoadGiveAways() {
        // Given
        let filterString = "Steam"
        
        // When
        viewModel.trigger(.handelQuickFilter(filterString))

        // Then
        XCTAssertEqual(viewModel.state.quickFilterString, filterString, "Quick filter string should be updated.")
        // Check if .loadGiveAways action is triggered correctly for the new filter string
        XCTAssertTrue(viewModel.state.isLoading, "The state should be loading when applying the quick filter.")
    }

    func testHandlePaginateGiveaways_ShouldUpdatePaginatedItems() {
        // Given
        let items = GiveAwayItem.mockArray(count: 25)
        viewModel.state.giveawayItems = [items]
        
        // When
        viewModel.trigger(.giveawayesResponse(.success(items)))
        viewModel.trigger(.loadGiveAways(nil, atPage: .next))

        // Then
        XCTAssertEqual(viewModel.state.paginatedItems.count, 20, "The paginated items count should be updated after pagination.")
        XCTAssertTrue(viewModel.state.shouldPaginate, "Pagination flag should be set correctly.")
    }

    func testHandlePaginateGiveaways_NoMoreItems_ShouldNotPaginate() {
        // Given
        let items = GiveAwayItem.mockArray(count: 15)
        viewModel.state.giveawayItems = [items]
        
        // When
        viewModel.trigger(.giveawayesResponse(.success(items)))
        viewModel.trigger(.loadGiveAways(nil, atPage: .next)) // Page 2 with no more items

        // Then
        XCTAssertFalse(viewModel.state.shouldPaginate, "Pagination flag should be false when there are no more items to paginate.")
    }

    func testLoadGiveAways_NilRequestModel_ShouldResetQuickFilter() {
        // Given
        viewModel.state.quickFilterString = "someFilter"
        let requestModel: GiveAwayRequestModel? = nil

        // When
        viewModel.trigger(.loadGiveAways(requestModel, atPage: .first))

        // Then
        XCTAssertTrue(viewModel.state.quickFilterString.isEmpty, "Quick filter string should reset when request model is nil.")
    }
}
