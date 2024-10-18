//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var nav: NavigationStateManager
    
    var body: some View {
        VStack {
            Text("Settings View")
        }
        .navigationTitle("Settings")
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    if nav.path.count > 0 {
//                        nav.path.removeLast()
//                    }
//                } label: {
//                    Image(systemName: "chevron.left.circle")
//                }
//            }
//        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationStateManager())
}
