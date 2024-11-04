//
//  DayDetailView.swift
//  Weather
//
//  Created by Mark Davis on 10/23/24.
//

import SwiftUI

struct DayDetailView: View {
    @EnvironmentObject var nav: NavigationStateManager

    let dayName: String
    let maxTemp: String
    let minTemp: String
    let precipitationProbability: String
    let precipitationAmount: String
    let uvIndex: String
    let sunrise: Date
    let sunset: Date

    var body: some View {
        VStack {
            Text(dayName)
                .font(.system(size: 36))
                .padding(.bottom, 10)

            VStack {
                Text("Max: \(maxTemp)°")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("Min: \(minTemp)°")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .padding(.bottom, 10)

            Text("Change of precipitation: \(precipitationProbability)%")
                .font(.system(size: 22))
                .foregroundStyle(.primary)

            Text("Precipitation amount: \(precipitationAmount)")
                .font(.system(size: 22))
                .foregroundStyle(.primary)
                .padding(.bottom, 10)

            Text("UV Index: \(uvIndex)")
                .font(.system(size: 22))
                .foregroundStyle(.primary)
        } //: VStack
        .padding(.bottom, 35)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if nav.path.count > 0 {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    DayDetailView(dayName: "Monday",
                  maxTemp: "22",
                  minTemp: "12",
                  precipitationProbability: "15",
                  precipitationAmount: "1",
                  uvIndex: "3",
                  sunrise: Date(),
                  sunset: Date())
}
