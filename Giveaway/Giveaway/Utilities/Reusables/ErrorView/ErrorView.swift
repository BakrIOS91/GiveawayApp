//
//  ErrorView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI

struct ErrorView: View {
    var apiError: APIError
    var didPressOnReload: () -> Void
    
    init(
        apiError: APIError,
        didPressOnReload: @escaping () -> Void = {}
    ) {
        self.apiError = apiError
        self.didPressOnReload = didPressOnReload
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            apiError.errorImage
                .resizable()
                .frame(width: 200, height: 200)
            
            Text(apiError.errorTitle)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(apiError.errorDescription)
                .font(.callout)
            
            if apiError.isReloadable {
                Button {
                    didPressOnReload()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text(StringConstants.common_Retry)
                            .font(.title3)
                            .padding(5)
                        
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ErrorView(apiError: .noNetwork)
}
