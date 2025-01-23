//
//  WindCardView.swift
//  Weather
//
//  Created by Mark Davis on 1/22/25.
//

import SwiftUI

struct WindCardView: View {
    var windSpeed: String
    var windGust: String
    var windDirectinoDegrees: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "wind")
                    .accessibilityLabel("wind icon")
                    .accessibilityAddTraits(.isImage)
                    .foregroundStyle(Color("TitleColor"))
                
                Text("Wind")
                    .accessibilityLabel("Wind")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.callout)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
            } //: HStack
            .padding(.bottom, 10)
            
            Divider()
                .foregroundStyle(Color("TitleColor"))
            
            HStack {
                Text("Wind speed")
                    .accessibilityLabel("Wind speed")
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
                
                Text(windSpeed)
                    .accessibilityLabel(windSpeed)
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .frame(minWidth: 45)
            } //: HStack
            
            Divider()
                .foregroundStyle(Color("TitleColor"))
            
            HStack {
                Text("Wind gust")
                    .accessibilityLabel("Wind gust")
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
                
                Text(windGust)
                    .accessibilityLabel(windGust)
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .frame(minWidth: 45)
            } //: HStack
            
            Divider()
                .foregroundStyle(Color("TitleColor"))

            HStack {
                Text("Wind direction")
                    .accessibilityLabel("Wind gust")
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
                
                Text("\(windDirectinoDegrees)°")
                    .accessibilityLabel(windDirectinoDegrees)
                    .accessibilityAddTraits(.isStaticText)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .frame(minWidth: 45)
            } //: HStack
        }
        .padding()
        .frame(minWidth: 300, idealWidth: 360, maxWidth: 370)
//        .frame(width: 360, height: 175, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    WindCardView(windSpeed: "14 km/h", windGust: "25 km/h", windDirectinoDegrees: "125")
}
