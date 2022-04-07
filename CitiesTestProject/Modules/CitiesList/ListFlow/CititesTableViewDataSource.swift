//
//  CititesTableViewDataSource.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

class CititesTableViewDataSource: NSObject, UITableViewDataSource {
	var source: [City]
	
	init(with source: [City] = []) {
		self.source = source
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return source.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithRegistration(type: CityCell.self, indexPath: indexPath)
		let city = source[indexPath.row]
		cell.update(with: city)
		return cell
	}
}
