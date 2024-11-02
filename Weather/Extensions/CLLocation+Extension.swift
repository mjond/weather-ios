//
//  CLLocation+Extension.swift
//  Weather
//
//  Created by Mark Davis on 11/2/24.
//

import CoreLocation

extension CLLocation {
    func fetchCity(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $1) }
    }
}
