//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Caio Luna on 10/01/26.
//

import UIKit

class GFAvatarImageView: UIImageView {
	
	let cache = NetworkManager.shared.cache

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.cornerRadius 	= 10
		clipsToBounds 			= true
		image 							= Images.placeholderImage
	}
}
