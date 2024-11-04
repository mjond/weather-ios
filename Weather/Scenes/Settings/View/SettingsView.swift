//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: WeatherSettings

    var body: some View {
        VStack(alignment: .leading) {
            Text("Unit of Measurement")
            Text("Current selection: " + settings.unitOfMeasurement.rawValue)

        } //: VStack
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
//                        .font(.system(size: 22))
//                        .foregroundStyle(.black)
//                }
//            }
//        }
    }
}

#Preview {
    @Previewable @State var settings = WeatherSettings()
    SettingsView(settings: $settings)
        .environmentObject(NavigationStateManager())
//    SettingsView()
}
