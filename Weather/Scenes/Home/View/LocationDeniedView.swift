//
//  LocationDeniedView.swift
//  Weather
//
//  Created by Mark Davis on 11/5/24.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .padding(.bottom, 20)
            Text("Location Access Denied")
                .font(.title3)
                .padding(.bottom, 5)
            Text("Go to Settings to approve Location Services for this app.")
                .multilineTextAlignment(.center)
                .padding()

        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    LocationDeniedView()
}
