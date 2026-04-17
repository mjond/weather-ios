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
                    .accessibilityLabel(cardIconName)
                    .accessibilityAddTraits(.isImage)
                    .foregroundStyle(Color("TitleColor"))

                Text(cardTitle)
                    .accessibilityLabel(cardTitle)
                    .accessibilityAddTraits(.isStaticText)
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
                        .accessibilityLabel("Loading")
                        .tint(Color("TitleColor"))

                    Text("Loading \(cardTitle)")
                        .accessibilityLabel("Loading \(cardTitle)")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color("TitleColor"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else if isUnavailable {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .accessibilityLabel("Data unavailable")
                        .accessibilityAddTraits(.isImage)
                        .font(.system(size: 24))
                        .foregroundStyle(Color("TitleColor"))

                    Text("Data Unavailable")
                        .accessibilityLabel("Data Unavailable")
                        .accessibilityAddTraits(.isStaticText)
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
                            .accessibilityLabel(item.key)
                            .accessibilityAddTraits(.isStaticText)
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))

                        Spacer()

                        Text(item.value)
                            .accessibilityLabel(item.value)
                            .accessibilityAddTraits(.isStaticText)
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
