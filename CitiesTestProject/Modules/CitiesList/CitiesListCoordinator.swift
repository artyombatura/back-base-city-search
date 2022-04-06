//
//  CitiesListCoordinator.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

protocol ICitiesListCoordinator {
	func startDetailsFlow(with city: City)
}

class CitiesListCoordinator: NavigationCoordinator, Presentable, ICitiesListCoordinator {
	func present() -> UIViewController {
		return rootController
	}
	
	override func start(animated _: Bool) {
		let citiesListViewModel = CitiesListViewModel(coordinator: self,
													  fetcherService: context.citiesService)
		let citiesListView = CitiesListViewController(viewModel: citiesListViewModel)
		
		push(citiesListView, animated: true, completion: nil)
	}
	
	func startDetailsFlow(with city: City) {
		print("Start details flow for: \(city.name), \(city.country)")
	}
}
