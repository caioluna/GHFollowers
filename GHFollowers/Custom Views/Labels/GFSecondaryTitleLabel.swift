//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Caio Luna on 12/02/26.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(fontSize: CGFloat) {
		super.init(frame: .zero)
		font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
		configure()
	}
	
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		textColor 								= .secondaryLabel
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor 				= 0.90
		lineBreakMode 						= .byTruncatingTail
	}
	
}
