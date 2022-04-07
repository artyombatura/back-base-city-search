//
//  StubbedCity.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation

enum StubbedCity {
	static let stubbed: [City] = [
		City(id: 1, name: "Alabama", country: "US", coordinates: .init(lon: 1, lat: 1)),
		City(id: 2, name: "Albuquerque", country: "US", coordinates: .init(lon: 1, lat: 1)),
		City(id: 3, name: "Anaheim", country: "US", coordinates: .init(lon: 1, lat: 1)),
		City(id: 4, name: "Arizona", country: "US", coordinates: .init(lon: 1, lat: 1)),
		City(id: 5, name: "Sydney", country: "AU", coordinates: .init(lon: 1, lat: 1)),
	]
}
