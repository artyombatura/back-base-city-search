//
//  CitiesListViewController.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

class CitiesListViewController: UIViewController {
	let coordinator: ICitiesListCoordinator
	
	init(coordinator: ICitiesListCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .yellow
	}
}
