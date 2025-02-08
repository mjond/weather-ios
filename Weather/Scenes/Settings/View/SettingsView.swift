//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel = SettingsViewModel()
    
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
                            isSelected: $viewModel.isImperialActive)
            .accessibilityLabel("Imperial: Miles, Inches, Fahrenheit, etc.")
            .accessibilityAddTraits(.isButton)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectImperial()
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))

            SettingsRowItem(title: "Celsius",
                            subHeading: "Kilometers, Millimeters, Celsius, etc.",
                            isSelected: $viewModel.isMetricActive)
            .accessibilityLabel("Celsius: Kilometers, Millimeters, Celsius, etc.")
            .accessibilityAddTraits(.isButton)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectMetric()
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 25)

            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(25)
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationStateManager())
}
