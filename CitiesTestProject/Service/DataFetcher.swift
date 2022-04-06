//
//  URLDataFetcher.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import Combine

protocol IDataFetcher {
	func fetchData(from path: String, withExtension: String) -> AnyPublisher<Data, Error>
}

class DataFetcher: IDataFetcher {
	func fetchData(from path: String, withExtension: String) -> AnyPublisher<Data, Error> {
		Bundle.main
			.readFile(from: path, withExtension: withExtension)
			.subscribe(on: DispatchQueue.global())
			.eraseToAnyPublisher()
	}
}

