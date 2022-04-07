//
//  CitiesListViewController.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit
import Combine

protocol CitiesListTableDelegate: AnyObject {
	func didSelectCity(city: City)
}

/// Represents view
class CitiesListView: UIViewController {
	let viewModel: CitiesListViewModel
	
	let tableDelegate = CitiesTableViewDelegate()
	let tableDataSource = CititesTableViewDataSource()
	
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
	
	private lazy var tableView: UITableView = {
		let table = UITableView(delegate: tableDelegate,
						   dataSource: tableDataSource)
		table.translatesAutoresizingMaskIntoConstraints = false
		table.isHidden = true
		return table
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
		tableDelegate.delegate = viewModel
		
		setupView()
		bind()
	}
	
	private func setupView() {
		self.title = "Cities"
		self.view.backgroundColor = .white
		
		self.view.addSubview(loadingView)
		self.view.addSubview(emptyLabelView)
		self.view.addSubview(tableView)
		
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
			
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
			self.show(loadingView)
			
		case .empty:
			self.show(emptyLabelView)
			
		case let .result(cities):
			self.show(tableView)
			
			self.tableDelegate.source = cities
			self.tableDataSource.source = cities
			tableView.reloadData()
		}
	}
	
	private func show(_ view: UIView) {
		self.view.subviews.forEach {
			$0.isHidden = (view != $0)
		}
	}
}

