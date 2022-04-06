//
//  CitiesListViewController.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit
import Combine

/// Represents view
class CitiesListViewController: UIViewController {
	let viewModel: CitiesListViewModel
	
	private lazy var loadingView: UIActivityIndicatorView = {
		let v = UIActivityIndicatorView(style: .medium)
		v.translatesAutoresizingMaskIntoConstraints = false
		v.startAnimating()
		return v
	}()
	
	private lazy var emptyLabelView: UILabel = {
		let label = UILabel(frame: .zero)
		label.textAlignment = .center
		label.text = "Nothing found. Try another filter query."
		label.isHidden = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private var cancellable = Set<AnyCancellable>()
	
	init(viewModel: CitiesListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		bind()
	}
	
	private func setupView() {
		self.view.backgroundColor = .white
		
		self.title = "Cities"
		
		self.view.addSubview(loadingView)
		self.view.addSubview(emptyLabelView)
		
		makeConstraints()
	}
	
	private func makeConstraints() {
		NSLayoutConstraint.activate([
			loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			emptyLabelView.topAnchor.constraint(equalTo: view.topAnchor),
			emptyLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			emptyLabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			emptyLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
	
	private func bind() {
		viewModel.$state
			.sink { [weak self] newState in
				self?.handleNewState(newState)
			}
			.store(in: &cancellable)
	}
	
	private func handleNewState(_ state: CitiesListViewModel.DisplayState) {
		switch state {
		case .loading:
			self.loadingView.isHidden = false
			self.emptyLabelView.isHidden = true
		case .empty:
			self.loadingView.isHidden = true
			self.emptyLabelView.isHidden = false
		case .cities:
			print("Display cities")
		}
	}
	
}


