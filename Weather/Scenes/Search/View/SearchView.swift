//
//  LocationSearchView.swift
//  Weather
//
//  Created by Mark Davis on 11/13/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var nav: NavigationStateManager

    @ObservedObject var viewModel: SearchViewModel = SearchViewModel()

    @State var locationManager: LocationManager
    @State var searchService = LocationSearchService()
    @State var isSearchingForCity: Bool = false

    var body: some View {
        VStack {
            Spacer()
                                            
            if searchService.results.isEmpty {
                Text("No location results")
                    .accessibilityLabel("No location results. Search for a location to see results.")
                    .accessibilityAddTraits(.isStaticText)
                    .foregroundStyle(Color("TitleColor"))
                    .fontDesign(.serif)
                    .padding(.bottom, 350)
            } else {
                List(searchService.results) { result in
                    Button {
                        if !isSearchingForCity {
                            isSearchingForCity = true
                            
                            viewModel.getLocation(locationName: result.title) { result in
                                if let newLocation = result {
                                    locationManager.lastLocation = newLocation
                                    if nav.path.count > 0 {
                                        nav.path.removeLast()
                                    }
                                    isSearchingForCity = false
                                } else {
                                    isSearchingForCity = false
                                }
                            }
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.title3)
                                .bold()
                                .fontDesign(.serif)
                            Text(result.subtitle)
                                .font(.subheadline)
                                .fontDesign(.serif)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color("BackgroundColor"))
                } //: List
                .scrollContentBackground(.hidden)
            }
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color("BackgroundColor"))
        .navigationBarBackButtonHidden()
        .searchable(text: $searchService.query, prompt: "Search city name")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if nav.path.count > 0 {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(Color("TitleColor"))
                }
            }
        }
    }
}

#Preview {
    SearchView(locationManager: LocationManager())
}
