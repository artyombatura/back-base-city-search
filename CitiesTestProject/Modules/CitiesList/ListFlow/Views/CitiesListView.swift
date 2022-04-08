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
	enum Constants {
		static let screenTitle: String = "Cities"
		static let emptyTitle: String = "Nothing found.\nTry another filter query."
		static let searchPlaceholder: String = "Start inputing city name"
	}
	
	private let viewModel: CitiesListViewModel
	
	private let tableDelegate = CitiesTableViewDelegate()
	private let tableDataSource = CititesTableViewDataSource()
	private let textFieldDelegate = BaseTextFieldDelegate()
	
	private lazy var loadingView: UIActivityIndicatorView = {
		let v = UIActivityIndicatorView(style: .medium)
		v.translatesAutoresizingMaskIntoConstraints = false
		v.startAnimating()
		return v
	}()
	
	private lazy var navBarLoadingView: UIActivityIndicatorView = UIActivityIndicatorView()
	
	private lazy var emptyLabelView: UILabel = {
		let label = UILabel(frame: .zero)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = Constants.emptyTitle
		label.textColor = .gray
		label.isHidden = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var tableView: UITableView = {
		let table = UITableView(delegate: tableDelegate,
						   dataSource: tableDataSource)
		table.translatesAutoresizingMaskIntoConstraints = false
		table.isHidden = true
		table.keyboardDismissMode = .interactive
		return table
	}()
	
	private lazy var searchBar: UISearchBar = {
		let bar = UISearchBar()
		bar.isHidden = true
		bar.translatesAutoresizingMaskIntoConstraints = false
		bar.placeholder = Constants.searchPlaceholder
		bar.searchTextField.delegate = textFieldDelegate
		return bar
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
		self.title = Constants.screenTitle
		self.view.backgroundColor = .white
		
		self.view.addSubview(loadingView)
		self.view.addSubview(emptyLabelView)
		self.view.addSubview(searchBar)
		self.view.addSubview(tableView)
		
		let barActivityIndicator = UIBarButtonItem(customView: navBarLoadingView)
		navigationItem.rightBarButtonItem = barActivityIndicator
		
		makeConstraints()
	}
	
	private func makeConstraints() {
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			searchBar.heightAnchor.constraint(equalToConstant: 44),
			
			loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			emptyLabelView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			emptyLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			emptyLabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			emptyLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func bind() {
		/// Binding view's output
		searchBar.searchTextField.textPublisher
			.assign(to: \.filterQuery, on: viewModel)
			.store(in: &cancellable)
		
		/// Receiving input to update
		viewModel.$state
			.receive(on: DispatchQueue.main)
			.sink { [weak self] newState in
				self?.handleNewState(newState)
			}
			.store(in: &cancellable)
		
		KeyboardPublisher.keyboardWillShow
			.sink { [weak self] expectedKeyboardHeight in
				guard let self = self else {
					return
				}
				let insets = UIEdgeInsets(top: 0, left: 0, bottom: expectedKeyboardHeight, right: 0)
				self.tableView.contentInset = insets
				self.tableView.scrollIndicatorInsets = insets
			}
			.store(in: &cancellable)
		
		KeyboardPublisher.keyboardWillHide
			.sink { [weak self] in
				guard let self = self else {
					return
				}
				let insets: UIEdgeInsets = .zero
				self.tableView.contentInset = insets
				self.tableView.scrollIndicatorInsets = insets
			}
			.store(in: &cancellable)
	}
	
	private func handleNewState(_ state: CitiesListViewModel.DisplayState) {
		switch state {
		case .loading:
			self.show(loadingView)
			
		case .filtering:
			self.navBarLoadingView.startAnimating()
			
		case .empty:
			self.show(emptyLabelView, ignore: searchBar)
			self.navBarLoadingView.stopAnimating()
			
		case let .result(cities):
			self.show(tableView, ignore: searchBar)
			self.navBarLoadingView.stopAnimating()
			
			self.tableDelegate.source = cities
			self.tableDataSource.source = cities
			tableView.reloadData()
		}
	}
	
	private func show(_ view: UIView, ignore views: UIView...) {
		self.view.subviews.forEach {
			$0.isHidden = (view != $0)
		}
		
		views.forEach { ignoredView in
			ignoredView.isHidden = false
		}
	}
}
