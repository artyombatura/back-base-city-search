//
//  CityCell.swift
//  CitiesTestProject
//
//  Created by Artyom Batura on 6.04.22.
//

import Foundation
import UIKit

class CityCell: UITableViewCell {
	
	enum Appearance {
		static let titleFontSize: CGFloat = 18
		static let subtitleFontSize: CGFloat = 14
		
		static let titleColor: UIColor = .black
		static let subtitleColor: UIColor = .gray
		
		static let labelOfssetX: CGFloat = 16
		static let labelOfssetY: CGFloat = 6
	}
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: Appearance.titleFontSize)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = Appearance.titleColor
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: Appearance.subtitleFontSize)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = Appearance.subtitleColor
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with city: City) {
		titleLabel.text = "\(city.name), \(city.country)"
		subtitleLabel.text = "\(city.coordinates.lon) : \(city.coordinates.lat)"
	}
	
	private func setupView() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(subtitleLabel)
		
		makeConstraints()
	}
	
	private func makeConstraints() {
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Appearance.labelOfssetY),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Appearance.labelOfssetX),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Appearance.labelOfssetX),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Appearance.labelOfssetY),
			subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Appearance.labelOfssetY)
		])
	}
}
