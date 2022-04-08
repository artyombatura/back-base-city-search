//
//  City.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation

struct City {
	let id: Int
	let name: String
	let country: String
	let coordinates: Coordinates
	
	struct Coordinates {
		let lon: Double
		let lat: Double
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
