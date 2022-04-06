//
//  CitiesListCoordinator.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

protocol ICitiesListCoordinator {
	func startDetailsFlow()
}

class CitiesListCoordinator: NavigationCoordinator, Presentable, ICitiesListCoordinator {
	func present() -> UIViewController {
		return rootController
	}
	
	override func start(animated _: Bool) {
		let baseController = CitiesListViewController(coordinator: self)
		push(baseController, animated: true, completion: nil)
	}
	
	func startDetailsFlow() {
		push(UIViewController(), animated: true, completion: nil)
	}
}
