//
//  DetailView.swift
//  Weather
//
//  Created by Mark Davis on 10/9/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var nav: NavigationStateManager
    @State private var showSettings: Bool = false
    
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
            
            Button {
//                nav.path.append("Settings View")
                showSettings.toggle()
            } label: {
                Text("Go to Settings")
            }

        }
//        .navigationDestination(for: String.self) { textValue in
//            SettingsView(text: textValue)
//        }
        .navigationDestination(isPresented: $showSettings, destination: {
            SettingsView()
        })
        .navigationTitle("Detail View")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if nav.path.count > 0 {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                }
            }
        }
    }
}

#Preview {
    DetailView(text: "Details")
        .environmentObject(NavigationStateManager())
}
