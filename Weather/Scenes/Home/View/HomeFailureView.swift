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
                .fontDesign(.serif)
                .padding(.bottom, 2)
            Text("Something went wrong...")
                .padding(.bottom, 20)
                .fontDesign(.serif)

            Button {
                tryAgainAction()
            } label: {
                Text("Try Again")
                    .fontDesign(.serif)
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
