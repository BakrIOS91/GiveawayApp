//
//  LookupFieldViewModelTests.swift
//  Giveaway
//
//  Created by Bakr Mohamed on 25/01/2025.
//

import XCTest
@testable import Giveaway

/// A test suite for the `LookupFieldViewModel` class.
/// This suite verifies the behavior of the `LookupFieldViewModel` under various scenarios,
/// including state initialization, user actions, and search functionality.
@MainActor
final class LookupFieldViewModelTests: XCTestCase {

    // MARK: - Properties

    var viewModel: LookupFieldViewModel!
    let mockLookupType: LookupType = .platform

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        viewModel = LookupFieldViewModel(lookupType: mockLookupType)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    func testInitialState_StateInitialized_CorrectValues() {
        // Given
        // Initial state is set when the ViewModel is initialized.

        // When
        // No action is performed, we just check the state after initialization.

        // Then
        XCTAssertEqual(viewModel.state.lookupType, mockLookupType)
        XCTAssertEqual(viewModel.state.lookupItems, mockLookupType.lookupItems)
        XCTAssertTrue(viewModel.state.filteredLookupItems.isEmpty)
        XCTAssertTrue(viewModel.state.selectedItems.isEmpty)
        XCTAssertFalse(viewModel.state.showLookupList)
        XCTAssertFalse(viewModel.state.isAllSelected)
        XCTAssertTrue(viewModel.state.searchText.isEmpty)
    }

    func testDidPressOnShowLookup_TogglesShowLookupList_TrueThenFalse() async {
        // Given
        // The initial state of showLookupList is false.

        // When
        viewModel.trigger(.didPressOnShowLookup)

        // Then
        XCTAssertTrue(viewModel.state.showLookupList)

        // When
        viewModel.trigger(.didPressOnShowLookup)

        // Then
        XCTAssertFalse(viewModel.state.showLookupList)
    }

    func testDidSelectLookupItem_SelectingThenDeselectingItem_UpdatesSelectedItems() async {
        // Given
        let item = mockLookupType.lookupItems[0]

        // When
        viewModel.trigger(.didSelectLookupItem(item))

        // Then
        XCTAssertTrue(viewModel.state.selectedItems.contains { $0.id == item.id })

        // When
        viewModel.trigger(.didSelectLookupItem(item))

        // Then
        XCTAssertFalse(viewModel.state.selectedItems.contains { $0.id == item.id })
    }

    func testDidPressOnSelectAll_SelectingThenDeselectingAllItems_UpdatesSelection() async {
        // Given
        // No items are selected initially.

        // When
        viewModel.trigger(.didPressOnSelectAll)

        // Then
        XCTAssertEqual(viewModel.state.selectedItems.count, mockLookupType.lookupItems.count)
        XCTAssertTrue(viewModel.state.isAllSelected)

        // When
        viewModel.trigger(.didPressOnSelectAll)

        // Then
        XCTAssertTrue(viewModel.state.selectedItems.isEmpty)
        XCTAssertFalse(viewModel.state.isAllSelected)
    }

    func testOnChangeSearchText_SearchTextChanged_FiltersLookupItems() async {
        // Given
        // Initial search text is empty, and all items are visible.

        // When
        viewModel.trigger(.onChangeSearchText("Steam"))

        // Then
        XCTAssertEqual(viewModel.state.searchText, "Steam")
        XCTAssertEqual(viewModel.state.filteredLookupItems.count, 1)
        XCTAssertEqual(viewModel.state.filteredLookupItems.first?.name, "Steam")

        // When
        viewModel.trigger(.onChangeSearchText(""))

        // Then
        XCTAssertTrue(viewModel.state.searchText.isEmpty)
        XCTAssertEqual(viewModel.state.filteredLookupItems.count, mockLookupType.lookupItems.count)

        // When
        viewModel.trigger(.onChangeSearchText("Nonexistent"))

        // Then
        XCTAssertTrue(viewModel.state.filteredLookupItems.isEmpty)
    }

    func testIsAllSelected_InitialState_FalseThenTrueThenFalse() async {
        // Given
        // Initial isAllSelected state is false.

        // When
        viewModel.trigger(.didPressOnSelectAll)

        // Then
        XCTAssertTrue(viewModel.state.isAllSelected)

        // When
        viewModel.trigger(.didSelectLookupItem(mockLookupType.lookupItems[0]))

        // Then
        XCTAssertFalse(viewModel.state.isAllSelected)
    }

    func testLookupItems_AfterLookupTypeChanged_MatchEnumCases() {
        // Given
        // Different LookupTypes: .platform, .type, and .sortBy.

        // When
        let platformViewModel = LookupFieldViewModel(lookupType: .platform)
        let typeViewModel = LookupFieldViewModel(lookupType: .type)
        let sortByViewModel = LookupFieldViewModel(lookupType: .sortBy)

        // Then
        XCTAssertEqual(platformViewModel.state.lookupItems.count, FilterPlatform.allCases.count)
        XCTAssertEqual(typeViewModel.state.lookupItems.count, FilterType.allCases.count)
        XCTAssertEqual(sortByViewModel.state.lookupItems.count, FilterSortBy.allCases.count)
    }
}
