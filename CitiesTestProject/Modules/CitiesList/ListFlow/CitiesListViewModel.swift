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
	
	// MARK: - For in-entity purposes
	
	/// Representation of all entities in user-defined data structure
	/// Used to perform fast searching with O(M) time complexity, where M is length of word inserted
	@Published private var citiesTrie = PrefixTrie<City>(elementStringMapper: { $0.name },
												 preCompareMapper: { $0.lowercased() })
	/// Used to keep largest sorted entry after fetching all objects
	/// Displaying this array when query is empty to prevent sorting 300k array every time when user cancels query
	private var initialySortedCities: [City] = []
	
	init(coordinator: ICitiesListCoordinator? = nil,
		 fetcherService: ICitiesService? = nil) {
		self.coordinator = coordinator
		self.fetcherService = fetcherService
		
		bind()
		
		fetchCities()
	}
	
	// MARK: - Private
	
	private func bind() {
		/// Combining to publishers with actual list of all cities and given query from user to compute filtered list
		/// When filtering is proccessed the output will be of type DisplayState and will be shared with the view
		$citiesTrie
			.combineLatest($filterQuery)
			.receive(on: queryProcessingQueue)
			.dropFirst()
			.map({ citiesTrie, query -> DisplayState in
				self.state = .filtering
				
				/// Defining which and how should display actual state of screen
				if query.isEmpty && !self.initialySortedCities.isEmpty {
					return .result(self.initialySortedCities)
				}
				
				let filtered = citiesTrie.search(query: query)
				if filtered.isEmpty {
					return .empty
				} else {
					return .result(filtered)
				}
			})
			.assign(to: &$state)
	}
	
	private func fetchCities() {
		fetcherService?
			.fetchCities()
			.map({ cities -> [City] in
				self.initialySortedCities = cities.sorted(by: { $0.name < $1.name })
				return cities
			})
			.receive(on: DispatchQueue.global(qos: .background))
			.sink(receiveValue: { [weak self] cities in
				guard let self = self else {
					return
				}
				
				/// Creation of nodes for prefix trie which will be used for all cities displaying in next steps
				let rootNode = PrefixTrie<City>.produceNodesChain(with: cities,
																  elementStringMapper: self.citiesTrie.elementStringMapper,
																  preCompareMapper: self.citiesTrie.preCompareMapper)
				
				self.citiesTrie = PrefixTrie<City>(root: rootNode,
											 elementStringMapper: self.citiesTrie.elementStringMapper,
											 preCompareMapper: self.citiesTrie.preCompareMapper)
			})
			.store(in: &cancellable)
	}
}

extension CitiesListViewModel: CitiesListTableDelegate {
	func didSelectCity(city: City) {
		coordinator?.startDetailsFlow(with: city)
	}
}
