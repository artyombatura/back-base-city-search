//
//  CityDetailViewModel.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation
import Combine
import MapKit

class CityDetailViewModel: ObservableObject {
	enum Constants {
		static let defaultLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
	}
	
	var coordinator: ICitiesListCoordinator?
	
	@Published var city: City
	
	// Output
	@Published var selectedLocation: CLLocation = Constants.defaultLocation
	
	init(city: City, coordinator: ICitiesListCoordinator?) {
		self.city = city
		self.coordinator = coordinator
		
		bind()
	}
	
	private func bind() {
		$city
			.map { city -> CLLocation in
				return CLLocation(latitude: city.coordinates.lat,
								  longitude: city.coordinates.lon)
			}
			.assign(to: &$selectedLocation)
	}
}
