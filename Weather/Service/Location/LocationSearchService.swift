//
//  LocationSearchService.swift
//  Weather
//
//  Created by Mark Davis on 11/13/24.
//

import Foundation
import MapKit

@Observable
class LocationSearchService: NSObject {
    var query: String = "" {
        didSet {
            handleSearchFragment(query)
        }
    }

    var results: [LocationResult] = []
    var status: SearchStatus = .idle

    var completer: MKLocalSearchCompleter

    init(filter: MKPointOfInterestFilter = .excludingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address])
    {
        completer = MKLocalSearchCompleter()

        super.init()

        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }

    private func handleSearchFragment(_ fragment: String) {
        status = .searching

        if !fragment.isEmpty {
            completer.queryFragment = fragment
        } else {
            status = .idle
            results = []
        }
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let filteredResults = completer.results.filter { $0.subtitle != "Search Nearby"
            && $0.subtitle != "No Results Nearby"
            && !$0.subtitle.contains("Dr")
            && !$0.subtitle.contains("Ave")
        }

        results = filteredResults.map { result in
            LocationResult(title: result.title, subtitle: result.subtitle)
        }

        status = .result
    }

    func completer(_: MKLocalSearchCompleter, didFailWithError error: any Error) {
        status = .error(error.localizedDescription)
    }
}

enum SearchStatus: Equatable {
    case idle
    case searching
    case error(String)
    case result
}
