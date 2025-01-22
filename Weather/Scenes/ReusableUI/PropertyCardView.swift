//
//  PropertyCardView.swift
//  Weather
//
//  Created by Mark Davis on 1/22/25.
//

import SwiftUI

struct PropertyCardView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.caption)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
                
                Image(systemName: "drop.fill")
                    .foregroundStyle(Color("TitleColor"))
            } //: HStack
            
            Spacer()

            HStack {
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
            } //: HStack
        }
        .padding()
        .frame(width: 150, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    PropertyCardView(title: "Precipitation", value: "15%")
}
