//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
//    @AppStorage(UserDefaultsConstants.appearance.rawValue) private var appearance: Appearance = .system

    @Binding var settings: WeatherSettings

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
            
            // MARK: - Appearance
//            Text("Appearance")
//                .fontWeight(.medium)
//                .fontDesign(.serif)
//                .foregroundStyle(Color("SubheadingColor"))
//
//            Divider()
//                .foregroundStyle(Color("TitleColor"))
//
//            SettingsRowItem(title: "Automatic",
//                            subHeading: "Use device settings",
//                            isSelected: $isSystemThemeActive)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if settings.appearance != .system {
//                    settings.appearance = .system
//                    
//                    isSystemThemeActive = true
//                    isLightThemeActive = false
//                    isDarkThemeActive = false
//                }
//            }
//
//            Divider()
//                .foregroundStyle(Color("TitleColor"))
//
//            SettingsRowItem(title: "Light",
//                            subHeading: "Always render in light mode",
//                            isSelected: $isLightThemeActive)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if settings.appearance != .light {
//                    settings.appearance = .light
//                    
//                    isSystemThemeActive = false
//                    isLightThemeActive = true
//                    isDarkThemeActive = false
//                }
//            }
//
//            Divider()
//                .foregroundStyle(Color("TitleColor"))
//
//            SettingsRowItem(title: "Dark",
//                            subHeading: "Always render in dark mode",
//                            isSelected: $isDarkThemeActive)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if settings.appearance != .dark {
//                    settings.appearance = .dark
//                    
//                    isSystemThemeActive = false
//                    isLightThemeActive = false
//                    isDarkThemeActive = true
//                }
//            }

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
            
//            if settings.appearance == .system {
//                isSystemThemeActive = true
//                isLightThemeActive = false
//                isDarkThemeActive = false
//            } else if settings.appearance == .light {
//                isSystemThemeActive = false
//                isLightThemeActive = true
//                isDarkThemeActive = false
//            } else if settings.appearance == .dark {
//                isSystemThemeActive = false
//                isLightThemeActive = false
//                isDarkThemeActive = true
//            }
        }
    }
}

#Preview {
    @Previewable @State var settings = WeatherSettings()
    SettingsView(settings: $settings)
        .environmentObject(NavigationStateManager())
}
