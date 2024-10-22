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
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                switch viewModel.state {
                case .isLoading:
                    VStack {
                        Text("loading...")
                    }
                case .failure:
                    VStack {
                        Text("failure")
                    }
                case let .success(weatherData):
                    VStack {
                        Text("current weather")
                        Text("\(weatherData.current.temperature)")
//                        Button {
//                            nav.path.append("Hello there")
//                            //                    showDetails.toggle()
//                        } label: {
//                            Text("Go to Details")
//                        }
                    } //: VStack
                    .padding()
                    .navigationTitle("Main View")
                    .navigationDestination(for: String.self) { textValue in
                        DetailView(text: textValue)
                    }
                }
            }
            .task {
                await viewModel.getWeather()
            }
        }
        .environmentObject(nav)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationStateManager())
    }
}
