//
//  TemperatureSettingsRowView.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

struct SettingsRowItem: View {
    let title: String
    let subHeading: String
    @Binding var isSelected: Bool

    var body: some View {
        HStack {
            if isSelected == true {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .padding(.trailing, 25)
            } else {
                Image(systemName: "circle")
                    .font(.system(size: 20))
                    .padding(.trailing, 25)
            }
                        
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                Text(subHeading)
                    .font(.subheadline)
            } //: VStack
            
            Spacer()
        } //: HStack
    }
}

#Preview {
    SettingsRowItem(title: "Imperial",
                               subHeading: "Miles, Fahrenheit, etc.",
                               isSelected: .constant(true))
}
