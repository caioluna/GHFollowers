//
//  FollowerCollectionViewCell.swift
//  GHFollowers
//
//  Created by Caio Luna on 10/01/26.
//

import UIKit

class FollowerCell: UICollectionViewCell {
	
	static let reuseId = "FollowerCell"
	
	let avatarImageView = GFAvatarImageView(frame: .zero)
	let usernameLabel 	= GFTitleLabel(textAlignment: .center, fontSize: 16)
	
	let padding: CGFloat = 8
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureAvatarImageView()
		configureUsernameLabel()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func set(follower: Follower) {
		usernameLabel.text = follower.login
		avatarImageView.downloadImage(from: follower.avatarUrl)
	}
	
	
	private func configureAvatarImageView() {
		addSubview(avatarImageView)
		
		NSLayoutConstraint.activate([
			avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
		])
	}
	
	
	private func configureUsernameLabel() {
		addSubview(usernameLabel)
	
		NSLayoutConstraint.activate([
			usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
			usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
			usernameLabel.heightAnchor.constraint(equalToConstant: 20)
		])
	}
}
