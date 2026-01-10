//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Caio Luna on 08/01/26.
//

import UIKit

class GFTitleLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
		super.init(frame: .zero)
		
		self.textAlignment = textAlignment
		self.font					 = UIFont.systemFont(ofSize: fontSize, weight: .bold)
		
		configure()
	}
	
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		textColor 								= .label
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor 				= 0.9
		lineBreakMode							= .byTruncatingTail
	}

}
