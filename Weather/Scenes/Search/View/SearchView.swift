//
//  LocationSearchView.swift
//  Weather
//
//  Created by Mark Davis on 11/13/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State var searchService = LocationSearchService()
    
    var body: some View {
        NavigationStack {
            VStack {
//                TextField("Search city name", text: $searchService.query)
//                    .fontDesign(.serif)
//                    .padding()
//                    .frame(width: 325, height: 40)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .strokeBorder(Color("TitleColor"), lineWidth: 1)
//                    )
//                    .background(.clear)
//                    .fontWeight(.bold)
                
                Spacer()
                                                
                if searchService.results.isEmpty {
                    Text("No location results")
                        .foregroundStyle(Color("TitleColor"))
                        .padding(.bottom, 350)
                } else {
                    List(searchService.results) { result in
                        VStack(alignment: .leading) {
                            // todo: customize this view
                            Text(result.title)
                            Text(result.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } //: VStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color("BackgroundColor"))
        } //: NavigationStack
        .searchable(text: $searchService.query)
    }
}

#Preview {
    LocationSearchView()
}
