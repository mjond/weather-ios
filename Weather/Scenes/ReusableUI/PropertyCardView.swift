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
                Image(systemName: iconName)
                    .accessibilityHidden(true)
                    .foregroundStyle(Color("TitleColor"))

                Text(title)
                    .font(.callout)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Spacer()
            } //: HStack

            Spacer()

            HStack {
                if isTimeBased {
                    if let unwrappedDate = date {
                        Text(unwrappedDate, format: .dateTime.hour().minute())
                            .font(.title)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                    }
                } else {
                    if let unwrappedValue = value {
                        Text(unwrappedValue)
                            .font(.title)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                    }
                }

                Spacer()
            } //: HStack
        }
        .padding()
        .frame(width: 165, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        if isTimeBased, let date {
            return "\(title), \(spokenTime(from: date))"
        }

        if let value {
            return "\(title), \(value)"
        }

        return title
    }

    private func spokenTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    PropertyCardView(title: "Precipitation", iconName: "drop.fill", value: "15%")
}
