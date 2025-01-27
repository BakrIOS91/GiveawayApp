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
    var placeholder: String
    var onChangeSearchText: (String) -> Void
    var didPressOnFilterButton: (() -> Void)?
    
    init(
        isFilterShown: Bool,
        placeholder: String = StringConstants.common_Search.text,
        onChangeSearchText: @escaping (String) -> Void,
        didPressOnFilterButton: (() -> Void)? = nil
    ) {
        self.isFilterShown = isFilterShown
        self.placeholder = placeholder
        self.onChangeSearchText = onChangeSearchText
        self.didPressOnFilterButton = didPressOnFilterButton
    }

    var body: some View {
        HStack {
            // Search Bar
            HStack {
                
                TextField(placeholder, text: $searchText)
                    .padding(.vertical, 10)
                    .padding(.trailing, 8)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        onChangeSearchText(searchText)
                    }
                    .padding(.leading)

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
                    .fill(.gray.opacity(0.25))
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
    SearchBarView(
        isFilterShown: true,
        placeholder: "Search Game by name", // Localized string placeholder
        onChangeSearchText: { searchText in
            print("Search text changed: \(searchText)")
        },
        didPressOnFilterButton: {
            print("Filter button pressed")
        }
    )
}
