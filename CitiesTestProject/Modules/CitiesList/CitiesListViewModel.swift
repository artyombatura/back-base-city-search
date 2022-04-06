//
//  CitiesListViewModel.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import Combine

final class CitiesListViewModel: ObservableObject {
	typealias DisplayState = Cities.State
	
	var coordinator: ICitiesListCoordinator
	var fetcherService: ICitiesService
	
	private var cancellable = Set<AnyCancellable>()
	
	// MARK: - Input
	
	// MARK: - Output
	@Published var state: Cities.State = .loading
	
	init(coordinator: ICitiesListCoordinator,
		 fetcherService: ICitiesService) {
		self.coordinator = coordinator
		self.fetcherService = fetcherService
		
		fetcherService
			.fetchCities()
			.receive(on: DispatchQueue.main)
			.map({ cities -> Cities.State in
				if cities.count == 0 {
					return .empty
				} else {
					return .cities(cities.count)
				}
			})
			.assign(to: &$state)
	}
	
	// MARK: - Methods
	// MARK: - Public
	
	// MARK: - Private
}
