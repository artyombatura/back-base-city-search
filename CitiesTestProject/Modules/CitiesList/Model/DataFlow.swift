//
//  DataFlow.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation

enum Cities {
	
	enum State {
		case loading
		case empty
		/// Temporary set to array of strings -> refactor to actual models
		case result([City])
	}

}
