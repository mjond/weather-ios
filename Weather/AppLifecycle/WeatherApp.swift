//
//  WeatherApp.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    @AppStorage(UserDefaultsConstants.appearance.rawValue) private var appearance: Appearance = .system

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
