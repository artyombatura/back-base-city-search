//
//  Keyboard+Publisher.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 8.04.22.
//

import Foundation
import UIKit
import Combine

enum KeyboardPublisher {
	static var keyboardWillShow: AnyPublisher<CGFloat, Never> {
		NotificationCenter.default
			.publisher(for: UIWindow.keyboardWillShowNotification)
			.map {
				guard
					let info = $0.userInfo,
					let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
				else { return 0 }
				
				return keyboardFrame.height
			}
			.eraseToAnyPublisher()
			.eraseToAnyPublisher()
	}

	static var keyboardWillHide: AnyPublisher<Void, Never> {
		NotificationCenter.default
			.publisher(for: UIWindow.keyboardWillHideNotification)
			.map({ _ in
				return Void()
			})
			.eraseToAnyPublisher()
			.eraseToAnyPublisher()
	}
}
