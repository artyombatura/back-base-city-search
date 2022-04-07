//
//  MockedCitiesService.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation
import Combine

class MockedCitiesService: ICitiesService {

	func fetchCities() -> AnyPublisher<[City], Never> {
		return Just<[City]>(StubbedCity.stubbed)
			.eraseToAnyPublisher()
	}
	
}
