//
//  SearchBarView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//
import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    var isFilterShown: Bool
    var onChangeSearchText: (String) -> Void
    var didPressOnFilterButton: (() -> Void)?
    
    init(
        isFilterShown: Bool,
        onChangeSearchText: @escaping (String) -> Void,
        didPressOnFilterButton: (() -> Void)? = nil
    ) {
        self.isFilterShown = isFilterShown
        self.onChangeSearchText = onChangeSearchText
        self.didPressOnFilterButton = didPressOnFilterButton
    }

    var body: some View {
        HStack {
            // Search Bar
            HStack {
                // Search Icon
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Search...", text: $searchText)
                    .padding(.vertical, 10)
                    .padding(.trailing, 8)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        onChangeSearchText(searchText)
                    }

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )

            if isFilterShown {
                // Filter Button
                Button(action: {
                    didPressOnFilterButton?()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                        )
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: searchText) {
            onChangeSearchText(searchText)
        }
    }
}

#Preview {
    SearchBarView(isFilterShown: true) { searchText in
        print("Search text changed: \(searchText)")
    } didPressOnFilterButton: {
        print("Filter button pressed")
    }
}
