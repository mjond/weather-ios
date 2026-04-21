//
//  ConditionsCardView.swift
//  Weather
//
//  Created by Mark Davis on 1/22/25.
//

import SwiftUI

struct ConditionsCardView: View {
    var cardIconName: String
    var cardTitle: String
    var rowItems: [String: String]
    var isLoading: Bool = false
    var isUnavailable: Bool = false

    var body: some View {
        VStack {
            HStack {
                Image(systemName: cardIconName)
                    .accessibilityHidden(true)
                    .foregroundStyle(Color("TitleColor"))

                Text(cardTitle)
                    .font(.callout)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Spacer()
            } //: HStack
            .padding(.bottom, 10)

            Divider()
                .foregroundStyle(Color("TitleColor"))

            if isLoading {
                VStack(spacing: 8) {
                    ProgressView()
                        .tint(Color("TitleColor"))

                    Text("Loading \(cardTitle)")
                        .fontDesign(.serif)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color("TitleColor"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else if isUnavailable {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .accessibilityHidden(true)
                        .font(.system(size: 24))
                        .foregroundStyle(Color("TitleColor"))

                    Text("Data Unavailable")
                        .fontDesign(.serif)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color("TitleColor"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else {
                ForEach(Array(rowItems.sorted { $0.key < $1.key }.enumerated()), id: \.element.key) { index, item in
                    HStack {
                        Text(item.key)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))

                        Spacer()

                        Text(item.value)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                            .frame(minWidth: 45)
                    } //: HStack

                    if index < rowItems.count - 1 {
                        Divider()
                            .foregroundStyle(Color("TitleColor"))
                    }
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        if isLoading {
            return "\(cardTitle), loading"
        }

        if isUnavailable {
            return "\(cardTitle), data unavailable"
        }

        let rows = rowItems
            .sorted { $0.key < $1.key }
            .map { "\($0.key), \($0.value)" }
            .joined(separator: ". ")

        if rows.isEmpty {
            return cardTitle
        }

        return "\(cardTitle). \(rows)"
    }
}

#Preview {
    ConditionsCardView(
        cardIconName: "wind",
        cardTitle: "Wind",
        rowItems: [
            "Wind speed": "14 km/h",
            "Wind gust": "25 km/h",
            "Wind direction": "125",
        ]
    )
}
