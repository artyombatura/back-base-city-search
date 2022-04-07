//
//  CitiesService.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import Combine

protocol ICitiesService {
	func fetchCities() -> AnyPublisher<[City], Never>
}

class CitiesService: ICitiesService {
	enum Constants {
		 static let citiesJSON = ("cities", "json")
	}
	
	let fetcher: IDataFetcher
	let jsonDecoder: JSONDecoder
	
	init(fetcher: IDataFetcher = DataFetcher(),
		 jsonDecoder: JSONDecoder = JSONDecoder()) {
		self.fetcher = fetcher
		self.jsonDecoder = jsonDecoder
	}
	
	func fetchCities() -> AnyPublisher<[City], Never> {
		return fetcher
			.fetchData(from: Constants.citiesJSON.0, withExtension: Constants.citiesJSON.1)
			.replaceError(with: Data())
			.receive(on: DispatchQueue.main)
			.map { data in
				guard let cities = try? self.jsonDecoder.decode([City].self, from: data) else {
					return []
				}
				return cities
			}
			.eraseToAnyPublisher()
			.eraseToAnyPublisher()
	}
}
