//
//  LookupFieldView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI

struct LookupFieldView: View {
    @Bindable var viewModel: LookupFieldViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.state.lookupType.lookupTitle)
            
            Button {
                viewModel.trigger(.didPressOnShowLookup)
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                        .fill(.white)
                        .frame(height: 60)
                    
                    HStack {
                        if viewModel.state.selectedItems.isEmpty {
                            Text(StringConstants.common_Select)
                        } else {
                            Text(viewModel.state.selectedItems.map({$0.name}).joined(separator: ","))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.blue)
                    }
                    .padding(.horizontal)
                }
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $viewModel.state.showLookupList) {
            LookupListView(viewModel: viewModel)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.6)])
                .presentationDragIndicator(.hidden)
        }
        
    }
}


#Preview {
    LookupFieldView(viewModel: .init(lookupType: .platform))
        .padding()
}
