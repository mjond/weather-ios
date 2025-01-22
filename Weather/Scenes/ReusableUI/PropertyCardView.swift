//
//  PropertyCardView.swift
//  Weather
//
//  Created by Mark Davis on 1/22/25.
//

import SwiftUI

struct PropertyCardView: View {
    var title: String
    var iconName: String
    var value: String?
    var isTimeBased: Bool = false
    var date: Date?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .accessibilityLabel("\(title)")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.callout)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                
                Spacer()
                
                Image(systemName: iconName)
                    .accessibilityLabel("\(iconName)")
                    .accessibilityAddTraits(.isImage)
                    .foregroundStyle(Color("TitleColor"))
            } //: HStack
            
            Spacer()

            HStack {
                Spacer()

                if isTimeBased {
                    if let unwrappedDate = date {
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: unwrappedDate)
                        
                        Text(unwrappedDate, format: .dateTime.hour().minute())
                            .accessibilityLabel(DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .spellOut) ?? "\(unwrappedDate)")
                            .accessibilityAddTraits(.isStaticText)
                            .font(.title)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                    }
                } else {
                    if let unwrappedValue = value {
                        Text(unwrappedValue)
                            .accessibilityLabel("\(unwrappedValue)")
                            .accessibilityAddTraits(.isStaticText)
                            .font(.title)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                    }
                }
            } //: HStack
        }
        .padding()
        .frame(width: 165, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    PropertyCardView(title: "Precipitation", iconName: "drop.fill", value: "15%")
}
