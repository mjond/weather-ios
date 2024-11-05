//
//  TemperatureSettingsRowView.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

struct TemperatureSettingsRowView: View {
    let title: String
    let subHeading: String
    @ObservedObject var unitOfMeasurementKey: WeatherSettings
    let isSelected: Bool

    private var iconName: String {
        if isSelected {
            return "checkmark.circle.fill"
        } else {
            return "circle"
        }
    }

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .padding(.trailing, 25)
                        
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                Text(subHeading)
                    .font(.subheadline)
            } //: VStack
            
            Spacer()
        } //: HStack
    }
}

#Preview {
    TemperatureSettingsRowView(title: "Imperial",
                               subHeading: "Miles, Fahrenheit, etc.",
                               unitOfMeasurementKey: WeatherSettings(),
                               isSelected: true)
}
