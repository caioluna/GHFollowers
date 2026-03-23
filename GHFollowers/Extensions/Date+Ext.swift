//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Caio Luna on 22/02/26.
//

import Foundation

extension Date {
	
	func convertToMonthYearFormat() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM yyyy"
		return dateFormatter.string(from: self)
	}
	
}
