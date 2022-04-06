//
//  City.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation

struct City {
	var id: Int
	var name: String
	var country: String
	var coordinates: Coordinates
	
	struct Coordinates {
		var lon: Double
		var lat: Double
	}
}

// MARK: - Decodable protocol conformans
//
extension City: Decodable {
	enum CodingKeys: String, CodingKey {
		case name, country
		case id = "_id"
		case coordinates = "coord"
	}
}

extension City.Coordinates: Decodable {
	enum CodingKeys: String, CodingKey {
		case lon, lat
	}
}
