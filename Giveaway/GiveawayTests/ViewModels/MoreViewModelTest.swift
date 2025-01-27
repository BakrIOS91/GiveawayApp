//
//  MoreViewModelTest.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

import XCTest
@testable import Giveaway
import Combine

@MainActor
final class MoreViewModelTests: XCTestCase {

    var viewModel: MoreViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = MoreViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = []
        super.tearDown()
    }

    func testLoadGiveAways_ShouldSetLoadingState() {
        // When
        viewModel.trigger(.loadGiveAways)

        // Then
        XCTAssertTrue(viewModel.state.isLoading, "Loading state should be true when loading giveaways.")
    }

    func testGiveawaysResponse_Success_ShouldPopulateItemsAndCarousal() {
        // Given
        let items = (1...10).map { GiveAwayItem.mock($0) }
        let result: Result<[GiveAwayItem]?, APIError> = .success(items)

        // When
        viewModel.trigger(.giveawayesResponse(result))

        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving a response.")
        XCTAssertEqual(viewModel.state.carusalItems.count, 5, "Carousel items should contain the first 5 items.")
        XCTAssertEqual(viewModel.state.items.keys.count, FilterPlatform.availableInMore.count, "Filtered items should have entries for all platforms.")
    }

    func testGiveawaysResponse_Failure_ShouldSetAPIError() {
        // Given
        let error = APIError.noData
        let result: Result<[GiveAwayItem]?, APIError> = .failure(error)

        // When
        viewModel.trigger(.giveawayesResponse(result))

        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving an error.")
        XCTAssertEqual(viewModel.state.apiError, error, "APIError should be set correctly on failure.")
    }

    func testDidSelectGiveawayItem_ShouldCreateDetailViewModel() {
        // Given
        let item = GiveAwayItem.mock(1)

        // When
        viewModel.trigger(.didSelectGiveawayItem(item))

        // Then
        XCTAssertNotNil(viewModel.state.detailsViewModel, "DetailsViewModel should be created when an item is selected.")
    }

    func testDidFavoriteGiveawayItem_ShouldToggleFavoriteState() {
        // Given
        let item = GiveAwayItem.mock(1)
        let items = [item]
        viewModel.state.items = ["TestPlatform": items]

        // When
        viewModel.trigger(.didFavoriteGiveawayItem(item))

        // Then
        let updatedItem = viewModel.state.items["TestPlatform"]?.first
        XCTAssertTrue(updatedItem?.isFavorite ?? false, "Item's favorite state should toggle to true.")

        // When toggling back
        viewModel.trigger(.didFavoriteGiveawayItem(updatedItem ?? item))

        // Then
        let revertedItem = viewModel.state.items["TestPlatform"]?.first
        XCTAssertFalse(revertedItem?.isFavorite ?? true, "Item's favorite state should toggle to false.")
    }
}
