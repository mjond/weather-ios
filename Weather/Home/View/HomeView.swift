//
//  ContentView.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var nav = NavigationStateManager()
    @State private var showDetails: Bool = false
        
    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                Button {
                    nav.path.append("Hello there")
//                    showDetails.toggle()
                } label: {
                    Text("Go to Details")
                }
            } //: VStack
            .padding()
            .navigationTitle("Main View")
            .navigationDestination(for: String.self) { textValue in
                DetailView(text: textValue)
            }
//            .navigationDestination(isPresented: $showDetails) {
//                DetailView(text: "Hello world")
//            }
        } //: NavigationStack
        .environmentObject(nav)
        
        VStack {
            Text("Number of items on nav stack: \(nav.path.count)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationStateManager())
    }
}
