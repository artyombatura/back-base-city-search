//
//  CityAnnotation.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 8.04.22.
//

import Foundation
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
	let city: City
	let coordinate: CLLocationCoordinate2D
	
	var title: String? {
		return "\(city.name), \(city.country)"
	}
	
	var subtitle: String? {
		return "\(city.coordinates.lat) : \(city.coordinates.lon)"
	}
	
	init(city: City) {
		self.city = city
		self.coordinate = CLLocationCoordinate2D(latitude: city.coordinates.lat,
												 longitude: city.coordinates.lon)
	}
}
