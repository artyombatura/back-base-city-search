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
	
	var coordinator: ICitiesListCoordinator?
	var fetcherService: ICitiesService?
	
	private var cancellable = Set<AnyCancellable>()
	
	private let queryProcessingQueue = DispatchQueue(label: "com.backbase.filtering_queue", qos: .userInteractive, attributes: .concurrent)
	
	// MARK: - Input
	
	/// User input for filtering, combined with cities publisher to result filtered cities
	@Published var filterQuery: String = ""
	
	// MARK: - Output
	
	/// Represents actual state
	/// Shared with the view
	@Published var state: DisplayState = .loading
	
	// MARK: - For inner purposes
	@Published var cities: [City] = []
	
	init(coordinator: ICitiesListCoordinator? = nil,
		 fetcherService: ICitiesService? = nil) {
		self.coordinator = coordinator
		self.fetcherService = fetcherService
		
		bind()
		
		fetchCities()
	}
	
	// MARK: - Methods
	// MARK: - Public
	
	// MARK: - Private
	private func bind() {
		/// Combining to publishers with actual list of all cities and given query from user to compute filtered list
		/// When filtering is proccessed the output will be of type DisplayState and will be shared with the view
		$cities
			.combineLatest($filterQuery)
			.receive(on: queryProcessingQueue)
			.dropFirst()
		/// Mapping received cities and filter query to make new cities array
			.map({ cities, query -> [City] in
				return cities
			})
		/// Sorting feature
			.map({ cities -> DisplayState in
				if cities.isEmpty { return .empty }

				let sortedCities = cities.sorted(by: { $0.name < $1.name })
				return .result(sortedCities)
			})
			.assign(to: &$state)
	}
	
	private func fetchCities() {
		fetcherService?
			.fetchCities()
			.receive(on: DispatchQueue.main)
			.assign(to: &$cities)
	}
}

extension CitiesListViewModel: CitiesListTableDelegate {
	func didSelectCity(city: City) {
		coordinator?.startDetailsFlow(with: city)
	}
}
