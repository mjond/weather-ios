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
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 50))
                .fontDesign(.serif)
                .padding(.bottom, 20)
            Text("Location Access Denied")
                .accessibilityLabel("Location Access Denied")
                .accessibilityAddTraits(.isStaticText)
                .font(.title3)
                .fontDesign(.serif)
                .padding(.bottom, 5)
            Text("Go to Settings to approve Location Services for this app.")
                .accessibilityLabel("In order to use Location Services, go to settings")
                .accessibilityAddTraits(.isStaticText)
                .multilineTextAlignment(.center)
                .fontDesign(.serif)
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
