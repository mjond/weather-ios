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

            Text("Settings")
                .font(.system(size: 42))
                .padding(.bottom, 20)
            
            Text("Unit of Measurement")
                .font(.title3)
            
            Divider()

            TemperatureSettingsRowView(title: "Imperial",
                                       subHeading: "Miles, Fahrenheit, etc.",
                                       unitOfMeasurementKey: settings,
                                       isSelected: settings.unitOfMeasurement == .imperial ? true : false)
            .onTapGesture {
                settings.unitOfMeasurement = .imperial
            }

            Divider()

            TemperatureSettingsRowView(title: "Celsius",
                                       subHeading: "Kilometers, Celsius, etc.",
                                       unitOfMeasurementKey: settings,
                                       isSelected: settings.unitOfMeasurement == .metric ? true : false)
            .onTapGesture {
                settings.unitOfMeasurement = .metric
            }

            Divider()

            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(25)
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
