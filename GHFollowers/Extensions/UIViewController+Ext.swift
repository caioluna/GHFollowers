//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Caio Luna on 09/01/26.
//

import UIKit
import SafariServices

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
}
