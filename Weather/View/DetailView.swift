//
//  DetailView.swift
//  Weather
//
//  Created by Mark Davis on 10/9/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var nav: NavigationStateManager
    
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
        }
        .navigationTitle("Detail View")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if nav.path.count > 0 {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                }
            }
        }
    }
}

#Preview {
    DetailView(text: "hello there")
        .environmentObject(NavigationStateManager())
}
