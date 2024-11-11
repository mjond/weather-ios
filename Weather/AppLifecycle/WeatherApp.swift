//
//  WeatherApp.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

@main
struct WeatherApp: App {
//    @ObservedObject var settings = WeatherSettings()
//    @Environment(\.colorScheme) private var colorScheme
//    @AppStorage(UserDefaultsConstants.appearance.rawValue) private var appearance: Appearance = .system

    var body: some Scene {
        WindowGroup {
            HomeView()
//                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
