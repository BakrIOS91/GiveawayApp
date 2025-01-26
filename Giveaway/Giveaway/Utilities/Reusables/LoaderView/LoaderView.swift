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
        BallPulseSync()
            .frame(width: 200, height: 60, alignment: .center)
            .foregroundColor(.blue)
    }
}

#Preview {
    LoaderView()
}
