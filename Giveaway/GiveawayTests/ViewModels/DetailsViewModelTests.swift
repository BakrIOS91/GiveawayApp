//
//  DetailsViewModel.swift
//  Giveaway
//
//  Created by Bakr mohamed on 27/01/2025.
//

import XCTest
@testable import Giveaway
import Combine

@MainActor
final class DetailedViewModelTests: XCTestCase {

    var viewModel: DetailedViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        viewModel = DetailedViewModel(1, isFavorite: false)
    }

    override func tearDown() {
        viewModel = nil
        cancellables = []
        super.tearDown()
    }

    func testLoadItemDetail_ShouldSetLoadingState() {
        // Given
        
        
        // When
        viewModel.trigger(.loadItemDetail)
        
        // Then
        XCTAssertTrue(viewModel.state.isLoading, "The loading state should be true when loading item details.")
    }

    func testDetailedItemResponse_Success_ShouldPopulateGiveawayItem() {
        // Given
        let item = GiveAwayItem.mock(1)
        let result: Result<GiveAwayItem?, APIError> = .success(item)
        
        // When
        viewModel.trigger(.detailedItemResponse(result))
        
        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving a response.")
        XCTAssertNotNil(viewModel.state.giveawayItem, "Giveaway item should be populated after a successful response.")
        XCTAssertEqual(viewModel.state.giveawayItem?.id, 1, "Giveaway item ID should match the expected value.")
    }

    func testDetailedItemResponse_Failure_ShouldSetAPIError() {
        // Given
        let error = APIError.noData
        let result: Result<GiveAwayItem?, APIError> = .failure(error)
        
        // When
        viewModel.trigger(.detailedItemResponse(result))
        
        // Then
        XCTAssertFalse(viewModel.state.isLoading, "Loading state should be false after receiving an error.")
        XCTAssertEqual(viewModel.state.apiError, error, "APIError should be set correctly on failure.")
    }

    func testDidPressOnFavorite_ToggleFavoriteState_ShouldUpdateCorrectly() {
        // Given
        let item = GiveAwayItem.mock(1)
        viewModel.state.giveawayItem = item
        viewModel.state.isFavorite = false
        
        // When
        viewModel.trigger(.didPressOnFavorite)
        
        // Then
        XCTAssertTrue(viewModel.state.giveawayItem?.isFavorite ?? false, "The item's favorite state should toggle to true.")
        
        // When toggling back
        viewModel.trigger(.didPressOnFavorite)
        
        // Then
        XCTAssertFalse(viewModel.state.giveawayItem?.isFavorite ?? true, "The item's favorite state should toggle to false.")
    }

    func testDidPressOnBackButton_ShouldNotifyBackButtonPress() {
        // Given
        let expectation = self.expectation(description: "Back button press notification received")
        viewModel.didPressOnBackButtonSubject
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.trigger(.didPressOnBacButton)
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }
}
