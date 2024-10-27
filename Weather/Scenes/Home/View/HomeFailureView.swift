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
                .font(.system(size: 50))
                .padding(.bottom, 2)
            Text("Something went wrong...")
                .padding(.bottom, 20)

            Button {
                tryAgainAction()
            } label: {
                Text("Tap Again")
            }

        }
    }
}

#Preview {
    HomeFailureView {
        print("try again")
    }
}
