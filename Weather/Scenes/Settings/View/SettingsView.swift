//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
    private var settings = WeatherSettings.shared

    @State var isImperialActive: Bool = true
    @State var isMetricActive: Bool = false
    
    @State var isSystemThemeActive: Bool = true
    @State var isLightThemeActive: Bool = false
    @State var isDarkThemeActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {

            Text("Settings")
                .accessibilityLabel("Settings")
                .accessibilityAddTraits(.isStaticText)
                .font(.system(size: 42))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 20)

            // MARK: - Unit of Measurement
            Text("Unit of Measurement")
                .accessibilityLabel("Unit of Measurement")
                .accessibilityAddTraits(.isStaticText)
                .fontWeight(.medium)
                .fontDesign(.serif)
                .foregroundStyle(Color("SubheadingColor"))

            Divider()

            SettingsRowItem(title: "Imperial",
                            subHeading: "Miles, Inches, Fahrenheit, etc.",
                            isSelected: $isImperialActive)
            .accessibilityLabel("Imperial: Miles, Inches, Fahrenheit, etc.")
            .accessibilityAddTraits(.isButton)
            .contentShape(Rectangle())
            .onTapGesture {
                if settings.unitOfMeasurement == .metric {
                    settings.unitOfMeasurement = .imperial
                    isImperialActive.toggle()
                    isMetricActive.toggle()
                }
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))

            SettingsRowItem(title: "Celsius",
                            subHeading: "Kilometers, Millimeters, Celsius, etc.",
                            isSelected: $isMetricActive)
            .accessibilityLabel("Celsius: Kilometers, Millimeters, Celsius, etc.")
            .accessibilityAddTraits(.isButton)
            .contentShape(Rectangle())
            .onTapGesture {
                if settings.unitOfMeasurement == .imperial {
                    settings.unitOfMeasurement = .metric
                    isImperialActive.toggle()
                    isMetricActive.toggle()
                }
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 25)

            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(25)
        .background(Color("BackgroundColor"))
        .onAppear {
            if settings.unitOfMeasurement == .imperial {
                isImperialActive = true
                isMetricActive = false
            } else {
                isImperialActive = false
                isMetricActive = true
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationStateManager())
}
