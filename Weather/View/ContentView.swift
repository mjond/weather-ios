//
//  ContentView.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var nav = NavigationStateManager()
        
    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                Button {
                    nav.path.append("Hello there")
                } label: {
                    Text("Go to Details")
                }
            } //: VStack
            .padding()
            .navigationTitle("Main View")
            .navigationDestination(for: String.self) { textValue in
                DetailView(text: textValue)
            }
        } //: NavigationStack
        .environmentObject(nav)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationStateManager())
    }
}
