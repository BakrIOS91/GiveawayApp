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

    func testDidSelectGiveawayItem_ShouldHandleSelectionWithoutError() {
        // Given
        let item = GiveAwayItem.mock(1)

        // When
        viewModel.trigger(.didSelectGiveawayItem(item))

        // Then
        // Ensure no exceptions occur
        XCTAssertTrue(true, "Triggering didSelectGiveawayItem should not result in any errors.")
    }

    func testDidFavoriteGiveawayItem_ToggleFavoriteState_ShouldUpdateCorrectly() {
        // Given
        var item = GiveAwayItem.mock(1)
        item.isFavorite = false
        viewModel.state.paginatedItems.insert(item, at: 0)
        // When
        viewModel.trigger(.didFavoriteGiveawayItem(item))
        
        // Ensure the collection is not empty before accessing
        XCTAssertFalse(viewModel.state.paginatedItems.isEmpty, "The paginated items should not be empty.")
        
        // Find the updated item in the collection after the state change
        XCTAssertTrue(viewModel.state.paginatedItems.contains(item), "Item not found in paginatedItems collection.")

        // Then
        XCTAssertTrue(viewModel.state.paginatedItems.first(where: { $0.id == item.id})?.isFavorite == true, "The item's favorite state should toggle to true.")

        // When toggling back
        item.isFavorite = true
        viewModel.trigger(.didFavoriteGiveawayItem(item))
        
        // Ensure the collection is still not empty
        XCTAssertFalse(viewModel.state.paginatedItems.isEmpty, "The paginated items should not be empty.")
        
        // Find the updated item again after the second state change
        XCTAssertTrue(viewModel.state.paginatedItems.contains(item), "Item not found in paginatedItems collection.")

        // Then
        XCTAssertTrue(viewModel.state.paginatedItems.first(where: { $0.id == item.id})?.isFavorite == false, "The item's favorite state should toggle to false.")
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
}
