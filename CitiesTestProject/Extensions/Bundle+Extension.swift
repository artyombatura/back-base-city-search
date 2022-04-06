//
//  Bundle+Extension.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import Combine

/// Extension to provide reactive data fetching from Bundle with use of Combine
extension Bundle {
	func readFile(from path: String, withExtension: String) -> AnyPublisher<Data, Error> {
		self.url(forResource: path, withExtension: withExtension)
			.publisher
			.tryMap { path in
				guard let data = try? Data(contentsOf: path) else {
					fatalError("Failed to load file from bundle.")
				}
				return data
			}
			.mapError { error in
				return error
			}
			.eraseToAnyPublisher()
	}
}
