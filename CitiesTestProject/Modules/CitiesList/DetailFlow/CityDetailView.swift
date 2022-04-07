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

class CityDetailViewModel: ObservableObject {
	enum Constants {
		static let defaultLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
	}
	
	var coordinator: ICitiesListCoordinator?
	
	@Published var city: City
	
	// Output
	@Published var selectedLocation: CLLocation = Constants.defaultLocation
	
	init(city: City, coordinator: ICitiesListCoordinator?) {
		self.city = city
		self.coordinator = coordinator
		
		bind()
	}
	
	private func bind() {
		$city
			.map { city -> CLLocation in
				return CLLocation(latitude: city.coordinates.lat,
								  longitude: city.coordinates.lon)
			}
			.assign(to: &$selectedLocation)
	}
}

private extension MKMapView {
	func centerToLocation(
		_ location: CLLocation,
		regionRadius: CLLocationDistance = 1500
	) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius)
		setRegion(coordinateRegion, animated: true)
	}
}

