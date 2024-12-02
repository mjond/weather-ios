//
//  HomeFailureView.swift
//  Weather
//
//  Created by Mark Davis on 10/26/24.
//

import SwiftUI

struct HomeFailureView: View {
    let tryAgainAction: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 50))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 2)
            Text("Something went wrong...")
                .accessibilityLabel("Something went wrong with getting weather data")
                .accessibilityAddTraits(.isStaticText)
                .padding(.bottom, 20)
                .foregroundStyle(Color("TitleColor"))
                .fontDesign(.serif)

            Button {
                tryAgainAction()
            } label: {
                Text("Try Again")
                    .accessibilityLabel("Try again to get weather data")
                    .accessibilityAddTraits(.isButton)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .underline()
            }
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    HomeFailureView {
        print("try again")
    }
}
