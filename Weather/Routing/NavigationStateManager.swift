//
//  NavigationStateManager.swift
//  Weather
//
//  Created by Mark Davis on 10/9/24.
//

import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var path = NavigationPath()

    func popToRoot() {
        path = NavigationPath()
    }
}
