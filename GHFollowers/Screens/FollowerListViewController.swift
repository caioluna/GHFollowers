//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 08/01/26.
//

import UIKit

class FollowerListViewController: UIViewController {
	
	enum Section { case main }
	
	var username: String!
	var followers: [Follower] = []
	var page: Int = 1
	var hasMoreFollowers = true
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureCollectionView()
		getFollowers(username: username, page: page)
		configureDataSource()
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
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.backgroundColor = .systemBackground
		collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
	}
	
	
	func getFollowers(username: String, page: Int) {
		
		Task {
			do {
				let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
				updateUI(with: followers)
			} catch {
				if let gfError = error as? GFError {
					presentGFAlert(title: "Something went wrong!", message: gfError.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
			}
		}
		
	}
	
	func updateUI(with followers: [Follower]) {
		if followers.count < NetworkManager.shared.usersPerPage { self.hasMoreFollowers = false }
		self.followers.append(contentsOf: followers)
		
		self.updateData(on: followers)
	}
	
	
	func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
			collectionView: collectionView,
			cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, follower: Follower) -> UICollectionViewCell? in
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
				cell.set(follower: follower)
				return cell
			})
	}
	
	
	func updateData(on followers: [Follower]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
		snapshot.appendSections([ Section.main ])
		snapshot.appendItems(followers)
		DispatchQueue.main.async {
			self.dataSource.apply(snapshot, animatingDifferences: true)
		}
	}
	
}

extension FollowerListViewController: UICollectionViewDelegate {
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height {
			guard hasMoreFollowers else { return }
			
			page += 1
			getFollowers(username: username, page: page)
		}
	}
	
}
