//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 28/01/26.
//

import UIKit

class UserInfoVC: UIViewController {
	
	let headerView = UIView()
	let itemViewOne = UIView()
	let itemViewTwo = UIView()
	var itemViews: [UIView] = []
	
	var username: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		layoutUI()
		getUserInfo()
	}
	
	
	func configureViewController() {
		view.backgroundColor = .systemBackground
		
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
		navigationItem.rightBarButtonItem = doneButton
	}
	
	
	func layoutUI() {
		let padding: CGFloat = 20
		let itemHeight: CGFloat = 140
		
		itemViews = [headerView, itemViewOne, itemViewTwo]
		
		for itemView in itemViews {
			view.addSubview(itemView)
			itemView.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor,  constant: padding),
				itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor,  constant: -padding),
			])
		}
		
		itemViewOne.backgroundColor = .systemCyan
		itemViewTwo.backgroundColor = .systemPink
		
		NSLayoutConstraint.activate([
			headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 180),
			
			itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
			itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
			
			itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
			itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
			
		])
	}
	
	
	func getUserInfo() {
		Task {
			let user = try await NetworkManager.shared.getUserInfo(for: username)
			self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
		}
	}
	
	
	func add(childVC: UIViewController, to containerView: UIView) {
		addChild(childVC)
		containerView.addSubview(childVC.view)
		childVC.view.frame = containerView.bounds
		childVC.didMove(toParent: self)
	}
	
	
	@objc func dismissViewController() {
		dismiss(animated: true)
	}
	
}
