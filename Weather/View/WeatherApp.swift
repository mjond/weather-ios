//
//  WeatherApp.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationStateManager())
        }
    }
}
