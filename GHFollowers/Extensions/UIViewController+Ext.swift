//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Caio Luna on 09/01/26.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
	
	func presentGFAlert(title: String, message: String, buttonTitle: String) {
		let alertViewController = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
		alertViewController.modalPresentationStyle = .overFullScreen
		alertViewController.modalTransitionStyle = .crossDissolve
		present(alertViewController, animated: true)
	}
	
	
	func presentDefaultError() {
		let alertViewController = GFAlertVC(title: "Something went wrong", message: "We were unable to complete your task at this time. Please try again.", buttonTitle: "OK")
		alertViewController.modalPresentationStyle = .overFullScreen
		alertViewController.modalTransitionStyle = .crossDissolve
		present(alertViewController, animated: true)
	}
	
	
	func presentSafariVC(with url: URL) {
		let safariVC = SFSafariViewController(url: url)
		present(safariVC, animated: true)
	}
	
	
	func showLoadingView() {
		containerView = UIView(frame: view.bounds)
		view.addSubview(containerView)
		
		containerView.backgroundColor = .systemBackground
		containerView.alpha = 0
		
		UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
		
		let activityIndicator = UIActivityIndicatorView(style: .large)
		containerView.addSubview(activityIndicator)
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
		
		activityIndicator.startAnimating()
	}
	
	func dismissLoadingView() {
		DispatchQueue.main.async {
			containerView.removeFromSuperview()
			containerView = nil
		}
	}
	
	func showEmptyStateView(with message: String, in view: UIView) {
		let emptyStateView = GFEmptyStateView(message: message)
		emptyStateView.frame = view.bounds
		
		view.addSubview(emptyStateView)
	}
	
}
