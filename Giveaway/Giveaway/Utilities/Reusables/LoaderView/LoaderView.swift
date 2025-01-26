//
//  LoaderView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI
import LoaderUI

struct LoaderView: View {
    var body: some View {
        VStack {
            Spacer()
            
            BallPulseSync()
                .frame(width: 200, height: 60, alignment: .center)
                .foregroundColor(.blue)
            
            Spacer()
        }
    }
}

#Preview {
    LoaderView()
}
