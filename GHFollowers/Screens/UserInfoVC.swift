//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 28/01/26.
//

import UIKit

class UserInfoVC: UIViewController {
	
	let scrollView = UIScrollView()
	let contentView = UIView()
	let headerView = UIView()
	let itemViewOne = UIView()
	let itemViewTwo = UIView()
	let dateLabel = GFBodyLabel(textAlignment: .center)
	var itemViews: [UIView] = []
	
	var username: String!
	weak var delegate: FollowerListVCDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewController()
		configureScrollView()
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
		
		itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
		
		for itemView in itemViews {
			contentView.addSubview(itemView)
			itemView.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,  constant: padding),
				itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,  constant: -padding),
			])
		}
		
		NSLayoutConstraint.activate([
			headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 210),
			
			itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
			itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
			
			itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
			itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
			
			dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
			dateLabel.heightAnchor.constraint(equalToConstant: 50),
		])
	}
	
	
	func configureScrollView() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		scrollView.pinToEdges(of: view)
		contentView.pinToEdges(of: scrollView)
		
		NSLayoutConstraint.activate([
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			contentView.heightAnchor.constraint(equalToConstant: 600),
		])
	}
	
	
	func getUserInfo() {
		Task {
			let user = try await NetworkManager.shared.getUserInfo(for: username)
			self.configureUIElements(with: user)
		}
	}
	
	
	func configureUIElements(with user: User) {
		let repoItemVC = GFRepoItemVC(user: user)
		repoItemVC.delegate = self
		
		let followerItemVC = GFFollowerItemVC(user: user)
		followerItemVC.delegate = self
		
		self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
		self.add(childVC: repoItemVC, to: self.itemViewOne)
		self.add(childVC: followerItemVC, to: self.itemViewTwo)
		self.dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormat())"
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


extension UserInfoVC: ItemInfoVCDelegate {
	
	func didTapGithubProfile(for user: User) {
		guard let url = URL(string: user.htmlUrl) else {
			presentGFAlert(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
			return
		}
		
		presentSafariVC(with: url)
	}
	
	func didTapGetFollowers(for user: User) {
		guard user.followers > 0 else {
			presentGFAlert(title: "No followers", message: "This user has no followers!", buttonTitle: "So sad")
			return
		}
		
		delegate.didRequestFollowers(for: user.login)
		dismissViewController()
	}
}
