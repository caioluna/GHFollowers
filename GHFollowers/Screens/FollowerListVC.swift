//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 08/01/26.
//

import UIKit

class FollowerListVC: UIViewController {
	
	enum Section { case main }
	
	var username: String!
	var followers: [Follower] = []
	var filteredFollowers: [Follower] = []
	var page: Int = 1
	var hasMoreFollowers: Bool = true
	var isSearching: Bool = false
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewController()
		configureSearchController()
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
			showLoadingView()
			
			do {
				let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
				
				updateUI(with: followers)
				dismissLoadingView()
				
				if followers.isEmpty {
					let message = "This user doesn't have any followers. Go follow them! 🙃"
					showEmptyStateView(with: message, in: self.view)
					return
				}
				
			} catch {
				if let gfError = error as? GFError {
					presentGFAlert(title: "Something went wrong!", message: gfError.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
			}
		}
		
	}
	
	
	func configureSearchController() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search for a user"
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
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

extension FollowerListVC: UICollectionViewDelegate {
	
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
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let activeArray = isSearching ? filteredFollowers : followers
		let follower = activeArray[indexPath.item]
		
		let destinationViewController = UserInfoVC()
		destinationViewController.username = follower.login
		let navigationController = UINavigationController(rootViewController: destinationViewController)
		present(navigationController, animated: true)
		
	}
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
		isSearching = true
		
		filteredFollowers = followers.filter({ follower in
			follower.login.lowercased().contains(filter.lowercased())
		})
		
		updateData(on: filteredFollowers)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearching = false
		updateData(on: followers)
	}
	
}
