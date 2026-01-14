//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Caio Luna on 09/01/26.
//

import UIKit

class NetworkManager {
	static let shared = NetworkManager()
	private let baseURL = "https://api.github.com"
	let usersPerPage = 50
	let cache = NSCache<NSString, UIImage>()
	let decoder = JSONDecoder()
	
	private init() {
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
	}
	
	
	func getFollowers(for username: String, page: Int) async throws -> [Follower] {
		let endpoint = baseURL + "/users/\(username)/followers?per_page=\(usersPerPage)&page=\(page)"
		
		guard let url = URL(string: endpoint) else {
			throw GFError.invalidUsername
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw GFError.invalidResponse
		}
		
		do {
			return try decoder.decode([Follower].self, from: data)
		} catch {
			throw GFError.invalidData
		}
		
	}
}
