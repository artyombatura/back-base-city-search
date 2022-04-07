//
//  CitiesTableViewDelegate.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

class CitiesTableViewDelegate: NSObject, UITableViewDelegate {
	weak var delegate: CitiesListTableDelegate?
	
	var source: [City]
	
	init(with source: [City] = []) {
		self.source = source
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let city = source[indexPath.row]
		delegate?.didSelectCity(city: city)
	}
}
