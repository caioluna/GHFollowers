//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 28/01/26.
//

import UIKit

class UserInfoVC: UIViewController {
	
	let headerView = UIView()
	
	var username: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
		navigationItem.rightBarButtonItem = doneButton
		
		layoutUI()
		
		Task {
			let user = try await NetworkManager.shared.getUserInfo(for: username)
			self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
		}
	}
	
	
	func layoutUI() {
		view.addSubview(headerView)
		headerView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 180),
		])
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
