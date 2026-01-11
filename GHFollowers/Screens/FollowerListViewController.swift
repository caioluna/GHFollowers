//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 08/01/26.
//

import UIKit

class FollowerListViewController: UIViewController {
	
	var username: String!
	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureCollectionView()
		getFollowers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	
	func configureViewController() {
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	
	func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemPurple
		collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseId)
	}
	
	
	func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
		let width 											= view.bounds.width
		let padding: CGFloat 						= 12
		let minimumItemSpacing: CGFloat = 10
		let availableWidth 							= width - (padding * 2) - (minimumItemSpacing * 2)
		let itemWidth 									= availableWidth / 3
		
		let flowLayout 									= UICollectionViewFlowLayout()
		flowLayout.sectionInset 				= UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		flowLayout.itemSize 						= CGSize(width: itemWidth, height: itemWidth + 40)
		
		return flowLayout
	}
	
	
	func getFollowers() {
		NetworkManager.shared.getFollowers(for: username, page: 1) { result in
			
			switch result {
			case .success(let followers):
				print("Followers qnty: \(followers.count)")
				print(followers)
			case .failure(let error):
				self.presentGFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "OK")
			}
		}
	}
	
}
