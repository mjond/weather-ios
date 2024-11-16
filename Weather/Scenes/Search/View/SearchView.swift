//
//  LocationSearchView.swift
//  Weather
//
//  Created by Mark Davis on 11/13/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var nav: NavigationStateManager
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var locationManager: LocationManager = LocationManager()
    @ObservedObject var viewModel: SearchViewModel = SearchViewModel()

    @State var searchService = LocationSearchService()
    @State var isSearchingForCity: Bool = false
    
    var body: some View {
        VStack {
//            TextField("Search city name", text: $searchService.query)
//                .fontDesign(.serif)
//                .padding()
//                .frame(width: 325, height: 40)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .strokeBorder(Color("TitleColor"), lineWidth: 1)
//                )
//                .background(.clear)
//                .fontWeight(.bold)
            
            Spacer()
                                            
            if searchService.results.isEmpty {
                Text("No location results")
                    .foregroundStyle(Color("TitleColor"))
                    .padding(.bottom, 350)
            } else {
                List(searchService.results) { result in
//                    Button {
//                        print("tapped \(result.title)")
//                    } label: {
//                        VStack(alignment: .leading) {
//                            Text(result.title)
//                                .listRowBackground(Color("BackgroundColor"))
//                            Text(result.subtitle)
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                                .listRowBackground(Color("BackgroundColor"))
//                        }
//                        .listRowBackground(Color("BackgroundColor"))
//                        .background(Color("BackgroundColor"))
//                    }

                    VStack(alignment: .leading) {
                        Text(result.title)
                            .listRowBackground(Color("BackgroundColor"))
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .listRowBackground(Color("BackgroundColor"))
                    }
                    .listRowBackground(Color("BackgroundColor"))
                    .onTapGesture {
                        if !isSearchingForCity {
                            isSearchingForCity = true
                            viewModel.getLocation(locationName: result.title) { result in
                                if let newLocation = result {
                                    locationManager.lastLocation = newLocation
                                    presentationMode.wrappedValue.dismiss()
                                    isSearchingForCity = false
                                } else {
                                    isSearchingForCity = false
                                }
                            }
                        }
                    }
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
    SearchView()
}
