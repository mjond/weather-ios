//
//  SearchModel.swift
//  Weather
//
//  Created by Mark Davis on 11/15/24.
//

import Foundation

struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
}
