//
//  SearchViewModel.swift
//  Weather
//
//  Created by Mark Davis on 11/16/24.
//

import CoreLocation
import SwiftUI
import Foundation

class SearchViewModel: ObservableObject {
    func getLocation(locationName: String, completion: @escaping (CLLocation?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationName) { placemarks, error in
            if error == nil {
                if let placemark = placemarks?[0] {
                    if let location = placemark.location {
                        return completion(location)
                    }
                }
            }
        }
    }
}
