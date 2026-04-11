//
//  WeatherApp.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import SwiftUI

@main
struct WeatherApp: App {
    private let persistence = PersistenceController.shared

    init() {
        configureAmplify()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }

    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
        } catch {
            print("Amplify configuration failed: \(error)")
        }
    }
}
