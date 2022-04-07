//
//  CitiesViewModelTests.swift
//  CitiesTestProjectTests
//
//  Created by Artyom Batura on 7.04.22.
//

import XCTest
import Combine
@testable import CitiesTestProject

class CitiesListViewModelTests: XCTestCase {
	
	var sut: CitiesListViewModel!
	var mockedCitiesService = MockedCitiesService()
	private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
		try super.setUpWithError()
		sut = CitiesListViewModel(fetcherService: mockedCitiesService)
		cancellables = []
    }

    override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
    }

	func testSearch() {
		let promise = self.expectation(description: "Cities fetch")
		
		sut.filterQuery = "s"
		
		sut.$state
			.sink { state in
				switch state {
				case let .result(cities):
					XCTAssertEqual(cities.count, 1)
					promise.fulfill()
					
				default:
					break
				}
			}
			.store(in: &cancellables)

		waitForExpectations(timeout: 10)
	}
}

