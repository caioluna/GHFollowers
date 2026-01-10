//
//  GFContainer.swift
//  GHFollowers
//
//  Created by Caio Luna on 09/01/26.
//

import UIKit

class GFContainer: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.cornerRadius 	= 16
		layer.borderWidth 	= 2
		layer.borderColor 	= UIColor.systemGray2.cgColor
		backgroundColor 		= .systemBackground
	}

}
