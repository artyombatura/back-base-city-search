//
//  CoordinatorContext.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation

class CoordinatorContext {
	enum Global {
		static let defMapRegionRadius: Double = 1500
	}
	
	let citiesService: ICitiesService
	
	init(citiesService: ICitiesService = CitiesService()) {
		self.citiesService = citiesService
	}
}
