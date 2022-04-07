//
//  UITextField+Publisher.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 7.04.22.
//

import Foundation
import UIKit
import Combine

extension UITextField {
	var textPublisher: AnyPublisher<String, Never> {
		NotificationCenter.default
			.publisher(for: UITextField.textDidChangeNotification, object: self)
		/// Receiving notifications with objects which are instances of UITextFields
			.compactMap { $0.object as? UITextField }
			.map { $0.text ?? "" }
			.eraseToAnyPublisher()
	}
}
