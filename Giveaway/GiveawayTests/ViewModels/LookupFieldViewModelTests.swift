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

    /// The view model under test.
    var viewModel: LookupFieldViewModel!

    /// The mock lookup type used for testing. Defaults to `.platform`.
    let mockLookupType: LookupType = .platform

    // MARK: - Setup and Teardown

    /// Sets up the test environment before each test case.
    /// Initializes the `viewModel` with the mock lookup type.
    override func setUp() {
        super.setUp()
        viewModel = LookupFieldViewModel(lookupType: mockLookupType)
    }

    /// Tears down the test environment after each test case.
    /// Resets the `viewModel` to `nil` to ensure a clean state for the next test.
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    /// Tests that the initial state of the `LookupFieldViewModel` is correctly configured.
    /// Verifies that the `lookupType`, `lookupItems`, `filteredLookupItems`, `selectedItems`,
    /// `showLookupList`, `isAllSelected`, and `searchText` properties are set to their expected default values.
    func testInitialStateIsCorrectlyConfigured() {
        XCTAssertEqual(viewModel.state.lookupType, mockLookupType)
        XCTAssertEqual(viewModel.state.lookupItems, mockLookupType.lookupItems)
        XCTAssertTrue(viewModel.state.filteredLookupItems.isEmpty)
        XCTAssertTrue(viewModel.state.selectedItems.isEmpty)
        XCTAssertFalse(viewModel.state.showLookupList)
        XCTAssertFalse(viewModel.state.isAllSelected)
        XCTAssertTrue(viewModel.state.searchText.isEmpty)
    }

    /// Tests that toggling the `showLookupList` state works as expected.
    /// Verifies that the `showLookupList` property toggles between `true` and `false`
    /// when the `didPressOnShowLookup` action is triggered.
    func testDidPressOnShowLookupTogglesShowLookupList() async {
        viewModel.trigger(.didPressOnShowLookup)
        XCTAssertTrue(viewModel.state.showLookupList)

        viewModel.trigger(.didPressOnShowLookup)
        XCTAssertFalse(viewModel.state.showLookupList)
    }

    /// Tests that selecting and deselecting a `LookupItem` updates the `selectedItems` array correctly.
    /// Verifies that:
    /// 1. Selecting an item adds it to the `selectedItems` array.
    /// 2. Deselecting the same item removes it from the `selectedItems` array.
    func testDidSelectLookupItemUpdatesSelectedItems() async {
        let item = mockLookupType.lookupItems[0]

        viewModel.trigger(.didSelectLookupItem(item))
        XCTAssertEqual(viewModel.state.selectedItems.count, 1)
        XCTAssertTrue(viewModel.state.selectedItems.contains { $0.id == item.id })

        viewModel.trigger(.didSelectLookupItem(item))
        XCTAssertTrue(viewModel.state.selectedItems.isEmpty)
        XCTAssertFalse(viewModel.state.selectedItems.contains { $0.id == item.id })
    }

    /// Tests that selecting all items and then deselecting all items works as expected.
    /// Verifies that:
    /// 1. Selecting all items adds all `lookupItems` to the `selectedItems` array.
    /// 2. Deselecting all items removes all items from the `selectedItems` array.
    func testDidPressOnSelectAllTogglesAllItemsSelection() async {
        viewModel.trigger(.didPressOnSelectAll)
        XCTAssertEqual(viewModel.state.selectedItems.count, mockLookupType.lookupItems.count)
        XCTAssertTrue(viewModel.state.isAllSelected)

        viewModel.trigger(.didPressOnSelectAll)
        XCTAssertTrue(viewModel.state.selectedItems.isEmpty)
        XCTAssertFalse(viewModel.state.isAllSelected)
    }

    /// Tests that changing the search text filters the `lookupItems` correctly.
    /// Verifies that:
    /// 1. Searching for a specific term filters the `lookupItems` to only include matching items.
    /// 2. Clearing the search text resets the `filteredLookupItems` to the full list of `lookupItems`.
    /// 3. Searching for a nonexistent term results in an empty `filteredLookupItems` array.
    func testOnChangeSearchTextFiltersLookupItems() async {
        let searchText = "Steam"
        viewModel.trigger(.onChangeSearchText(searchText))
        XCTAssertEqual(viewModel.state.searchText, searchText)
        XCTAssertEqual(viewModel.state.filteredLookupItems.count, 1)
        XCTAssertEqual(viewModel.state.filteredLookupItems.first?.name, "Steam")

        viewModel.trigger(.onChangeSearchText(""))
        XCTAssertTrue(viewModel.state.searchText.isEmpty)
        XCTAssertEqual(viewModel.state.filteredLookupItems.count, mockLookupType.lookupItems.count)

        viewModel.trigger(.onChangeSearchText("Nonexistent"))
        XCTAssertTrue(viewModel.state.filteredLookupItems.isEmpty)
    }

    /// Tests that the `isAllSelected` computed property correctly reflects whether all items are selected.
    /// Verifies that:
    /// 1. Initially, no items are selected, so `isAllSelected` is `false`.
    /// 2. After selecting all items, `isAllSelected` is `true`.
    /// 3. After deselecting one item, `isAllSelected` is `false`.
    func testIsAllSelectedReflectsCorrectState() async {
        XCTAssertFalse(viewModel.state.isAllSelected)

        viewModel.trigger(.didPressOnSelectAll)
        XCTAssertTrue(viewModel.state.isAllSelected)

        viewModel.trigger(.didSelectLookupItem(mockLookupType.lookupItems[0]))
        XCTAssertFalse(viewModel.state.isAllSelected)
    }

    /// Tests that the `lookupItems` are correctly populated based on the `LookupType`.
    /// Verifies that the number of `lookupItems` matches the number of cases in the corresponding enums:
    /// 1. `.platform` maps to `FilterPlatform.allCases`.
    /// 2. `.type` maps to `FilterType.allCases`.
    /// 3. `.sortBy` maps to `FilterSortBy.allCases`.
    func testLookupItemsAreCorrectlyPopulatedBasedOnLookupType() {
        let platformViewModel = LookupFieldViewModel(lookupType: .platform)
        XCTAssertEqual(platformViewModel.state.lookupItems.count, FilterPlatform.allCases.count)

        let typeViewModel = LookupFieldViewModel(lookupType: .type)
        XCTAssertEqual(typeViewModel.state.lookupItems.count, FilterType.allCases.count)

        let sortByViewModel = LookupFieldViewModel(lookupType: .sortBy)
        XCTAssertEqual(sortByViewModel.state.lookupItems.count, FilterSortBy.allCases.count)
    }
}
