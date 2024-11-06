//
//  HourlyCardView.swift
//  Weather
//
//  Created by Mark Davis on 10/26/24.
//

import SwiftUI

struct HourlyCardView: View {
    let date: Date
    let temp: String
    let weatherIconName: String

    var body: some View {
        VStack(alignment: .center) {
            Text(date, format: .dateTime.hour())
                .fontDesign(.serif)
                .foregroundStyle(Color("SubheadingColor"))
                .padding(.top, 10)
                .padding(.bottom, 1)
            
            Text(temp+"°")
                .fontWeight(.semibold)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
            
            Image(systemName: weatherIconName)
                .font(.system(size: 22))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
        }
        .frame(width: 55, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    HourlyCardView(date: Date.now,
                   temp: "14",
                   weatherIconName: "cloud.rain")
}
