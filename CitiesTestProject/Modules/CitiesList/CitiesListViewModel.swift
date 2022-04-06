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
	
	// MARK: - Input
	
	// MARK: - Output
	@Published var state: Cities.State = .loading
	
	init(coordinator: ICitiesListCoordinator) {
		self.coordinator = coordinator
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
			self.state = .empty
		})
	}
	
	// MARK: - Methods
	// MARK: - Public
	
	// MARK: - Private
}
