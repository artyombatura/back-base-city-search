//
//  CityDetailView.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit
import MapKit
import Combine

class CityDetailView: UIViewController {
	let viewModel: CityDetailViewModel
	
	private lazy var mapView: MKMapView = {
		let map = MKMapView()
		map.translatesAutoresizingMaskIntoConstraints = false
		return map
	}()
	
	private var cancellable = Set<AnyCancellable>()
	
	init(viewModel: CityDetailViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		bind()
	}
	
	private func setupView() {
		self.view.backgroundColor = .white
		self.view.addSubview(mapView)
		makeConstraints()
	}
	
	private func makeConstraints() {
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.topAnchor),
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
	
	private func bind() {
		viewModel.$selectedLocation
			.sink { [weak self] mappedLocation in
				self?.mapView.centerToLocation(mappedLocation)
			}
			.store(in: &cancellable)
	}
}
