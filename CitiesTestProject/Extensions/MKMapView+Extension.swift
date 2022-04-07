//
//  MKMapView+Extension.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation
import MapKit

extension MKMapView {
	func centerToLocation(
		_ location: CLLocation,
		regionRadius: CLLocationDistance = CoordinatorContext.Global.defMapRegionRadius
	) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius)
		setRegion(coordinateRegion, animated: true)
	}
}
