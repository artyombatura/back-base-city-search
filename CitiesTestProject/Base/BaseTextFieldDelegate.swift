//
//  BaseTextFieldDelegate.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 8.04.22.
//

import Foundation
import UIKit

class BaseTextFieldDelegate: NSObject, UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
