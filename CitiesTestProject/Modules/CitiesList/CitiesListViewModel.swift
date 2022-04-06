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
	
	let tableDelegate = CitiesTableViewDelegate()
	let tableDataSource = CititesTableViewDataSource()
	
	private var cancellable = Set<AnyCancellable>()
	
	// MARK: - Input
	@Published var filterQuery: String = ""
	
	// MARK: - Output
	@Published var state: Cities.State = .loading
	
	// MARK: - For inner purposes
	@Published var cities: [City] = []
	
	init(coordinator: ICitiesListCoordinator,
		 fetcherService: ICitiesService) {
		self.coordinator = coordinator
		self.fetcherService = fetcherService
		
		self.tableDelegate.delegate = self
		
		fetcherService
			.fetchCities()
			.receive(on: DispatchQueue.main)
			.assign(to: &$cities)
		
		$cities.combineLatest($filterQuery)
			.subscribe(on: DispatchQueue.global())
			.map({ cities, query -> DisplayState in
				self.tableDelegate.source = cities
				self.tableDataSource.source = cities
				
				return .result
			})
			.receive(on: DispatchQueue.main)
			.assign(to: &$state)
	}
	
	// MARK: - Methods
	// MARK: - Public
	
	// MARK: - Private
}

extension CitiesListViewModel: CitiesListTableDelegate {
	func didSelectCity(city: City) {
		// MARK: - Refactor! It's just a stub
		coordinator.startDetailsFlow(with: city)
	}
}
