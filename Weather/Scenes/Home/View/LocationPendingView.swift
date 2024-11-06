//
//  LocationPendingView.swift
//  Weather
//
//  Created by Mark Davis on 11/6/24.
//

import SwiftUI

struct LocationPendingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .foregroundStyle(Color("TitleColor"))
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    LocationPendingView()
}
