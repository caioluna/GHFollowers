//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Caio Luna on 09/01/26.
//

import UIKit

extension UIViewController {
	
	func presentGFAlert(title: String, message: String, buttonTitle: String) {
		let alertViewController = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
		alertViewController.modalPresentationStyle = .overFullScreen
		alertViewController.modalTransitionStyle = .crossDissolve
		present(alertViewController, animated: true)
	}
	
	func presentDefaultError() {
		let alertViewController = GFAlertViewController(title: "Something went wrong", message: "We were unable to complete your task at this time. Please try again.", buttonTitle: "OK")
		alertViewController.modalPresentationStyle = .overFullScreen
		alertViewController.modalTransitionStyle = .crossDissolve
		present(alertViewController, animated: true)
	}
	
}
