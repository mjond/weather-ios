//
//  WeatherApp.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    private let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
