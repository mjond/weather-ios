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
                .padding(.top, 10)
                .padding(.bottom, 1)
            
            Text(temp+"°")
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(systemName: weatherIconName)
                .font(.system(size: 22))
            
            Spacer()
        }
        .frame(width: 55, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black, lineWidth: 1)
        )
    }
}

#Preview {
    HourlyCardView(date: Date.now,
                   temp: "14",
                   weatherIconName: "cloud.rain")
}
