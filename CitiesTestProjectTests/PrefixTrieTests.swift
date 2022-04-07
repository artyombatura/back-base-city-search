//
//  PrefixTrieTests.swift
//  CitiesTestProjectTests
//
//  Created by Artyom Batura on 7.04.22.
//

import XCTest
@testable import CitiesTestProject

class PrefixTrieTests: XCTestCase {
	
	var sut: PrefixTrie<City>!

    override func setUpWithError() throws {
		try super.setUpWithError()
		
		sut = PrefixTrie(elementStringMapper: { $0.name },
						 preCompareMapper: { $0.lowercased() })
		StubbedCity.stubbed.forEach({ sut.insert(element: $0) })
    }

    override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
    }
	
	func testDefaultSuccessSearch() {
		let searchQuery = "A"
		let result = sut.search(query: searchQuery)
		
		XCTAssertEqual(result.count, 4)
	}

	func testCaseInsensitiveSearch() {
		let searchQuery = "a"
		let result = sut.search(query: searchQuery)
		
		XCTAssertEqual(result.count, 4)
	}
	
	func testEmptyResultSearch() {
		/// Search query with use of which we are expecting empty result, since defined stubbed cities doesn't contain city which starts with 'm'/'M'
		let searchQuery = "m"
		let result = sut.search(query: searchQuery)
		
		XCTAssertEqual(result.count, 0)
	}

	/// Expectiing to return all entries
	func testEmptyQuery() {
		let searchQuery = ""
		let result = sut.search(query: searchQuery)
		
		XCTAssertEqual(result.count, 5)
	}
}
