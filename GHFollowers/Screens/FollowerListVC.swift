//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by Caio Luna on 08/01/26.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
	func didRequestFollowers(for username: String)
}

class FollowerListVC: GFDataLoadingVC {
	
	enum Section { case main }
	
	var username: String!
	var followers: [Follower] = []
	var filteredFollowers: [Follower] = []
	var page: Int = 1
	var hasMoreFollowers: Bool = true
	var isSearching: Bool = false
	var isLoadingMoreFollowers: Bool = false
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
	
	init(username: String) {
		super.init(nibName: nil, bundle: nil)
		self.username = username
		title = username
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
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
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
	
	
	@objc func addButtonTapped() {
		
		Task {
			showLoadingView()
			
			do {
				let user = try await NetworkManager.shared.getUserInfo(for: username)
				
				dismissLoadingView()
				
				addUserToFavorites(user: user)
				
			} catch {
				
				if let gfError = error as? GFError {
					presentGFAlert(title: "Something went wrong!", message: gfError.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
			}
		}
	}
	
	
	func addUserToFavorites(user: User) {
		let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
		
		PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
			guard let self else { return }
			guard let error = error else {
				self.presentGFAlert(title: "Success!", message: "You have favorited this user.", buttonTitle: "Woohoo!")
				return
			}
			
			presentGFAlert(title: "Something went wrong!", message: error.rawValue, buttonTitle: "OK")
		}
	}
	
	
	func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.backgroundColor = .systemBackground
		collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
	}
	
	
	func getFollowers(username: String, page: Int) {
		showLoadingView()
		isLoadingMoreFollowers = true
		
		Task {
			do {
				let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
				
				updateUI(with: followers)
				self.dismissLoadingView()
				
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
			
			self.isLoadingMoreFollowers = false
		}
	}
	
	
	func configureSearchController() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
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
			guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
			
			page += 1
			getFollowers(username: username, page: page)
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let activeArray = isSearching ? filteredFollowers : followers
		let follower = activeArray[indexPath.item]
		
		let destVC = UserInfoVC()
		destVC.username = follower.login
		destVC.delegate = self
		
		let navigationController = UINavigationController(rootViewController: destVC)
		present(navigationController, animated: true)
	}
}


extension FollowerListVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let filter = searchController.searchBar.text, !filter.isEmpty else {
			filteredFollowers.removeAll()
			updateData(on: followers)
			isSearching = false
			return
		}
		
		isSearching = true
		
		filteredFollowers = followers.filter({ follower in
			follower.login.lowercased().contains(filter.lowercased())
		})
		
		updateData(on: filteredFollowers)
	}
}


extension FollowerListVC: FollowerListVCDelegate {
	func didRequestFollowers(for username: String) {
		self.username = username
		title = username
		page = 1
		followers.removeAll()
		filteredFollowers.removeAll()
		collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
		getFollowers(username: username, page: page)
	}
}
