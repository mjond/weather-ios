//
//  SettingsView.swift
//  Weather
//
//  Created by Mark Davis on 10/18/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: WeatherSettings
    @State var isImperialActive: Bool = true
    @State var isMetricActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {

            Text("Settings")
                .font(.system(size: 42))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 20)

            Text("Unit of Measurement")
                .fontWeight(.medium)
                .fontDesign(.serif)
                .foregroundStyle(Color("SubheadingColor"))

            Divider()

            SettingsRowItem(title: "Imperial",
                            subHeading: "Miles, Inches, Fahrenheit, etc.",
                            isSelected: $isImperialActive)
            .onTapGesture {
                settings.unitOfMeasurement = .imperial
                isImperialActive.toggle()
                isMetricActive.toggle()
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))

            SettingsRowItem(title: "Celsius",
                            subHeading: "Kilometers, Millimeters, Celsius, etc.",
                            isSelected: $isMetricActive)
            .onTapGesture {
                settings.unitOfMeasurement = .metric
                isImperialActive.toggle()
                isMetricActive.toggle()
            }

            Divider()
                .foregroundStyle(Color("TitleColor"))
//                .padding(.bottom, 25)
//            
//            Text("Appearance")
//                .fontWeight(.medium)
//                .fontDesign(.serif)
//                .foregroundStyle(Color("SubheadingColor"))

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
