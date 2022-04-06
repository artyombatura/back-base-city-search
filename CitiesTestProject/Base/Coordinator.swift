//
//  Coordinator.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import UIKit

/// Protocol for view controllers that can be presented
public protocol Presentable {
	/**
		 Function to get view controller that can be presented.

		 - returns: This view controller.
	 **/
	func present() -> UIViewController
}

extension UIViewController: Presentable {
	public func present() -> UIViewController {
		return self
	}
}

class Coordinator: NSObject {
	private(set) weak var controller: UIViewController?

	init(root controller: UIViewController) {
		self.controller = controller
	}

	init(coordinator: Coordinator) {
		controller = coordinator.controller
	}

	deinit {
		print("\(self) has deinited")
	}

	// MARK: -

	func start(animated _: Bool) {}

	// MARK: - Private

	fileprivate func present(_ presentable: Presentable) -> UIViewController {
		let controller = presentable.present()
		return controller
	}
}

class NavigationCoordinator: Coordinator {
	let rootController: UINavigationController

	init(root controller: UINavigationController) {
		rootController = controller
		super.init(root: controller)
	}

	init(coordinator: NavigationCoordinator) {
		rootController = coordinator.rootController
		super.init(coordinator: coordinator)
	}
	
	// MARK: -

	func push(_ presentable: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
		rootController.pushViewController(present(presentable), animated: animated)
	}

	func pop(animated: Bool, completion: (() -> Void)? = nil) {
		rootController.popViewController(animated: animated)
	}
}

/// Main coordinator entity in application
///
/// While application contains only one navigation flow (List->Details) it's subclass from base NavigationCoordinator
/// In future if needed we can add new entity, for example TabCoordinator to control multiple tabs
class AppCoordinator: NavigationCoordinator {
	let window: UIWindow?
	
	let baseNavigationController = UINavigationController()
	
	init(window: UIWindow?) {
		self.window = window
		super.init(root: baseNavigationController)

	}
	
	// MARK: - Overrides
	override func start(animated _: Bool) {
		let citiesFlow = CitiesListCoordinator(coordinator: self)
		citiesFlow.start(animated: true)
		
		window?.rootViewController = baseNavigationController
		window?.makeKeyAndVisible()
	}
}
