//
//  NetworkService.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

protocol NetworkServiceInputProtocol {
	func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void)
	func getData(at path: URL, completion: @escaping (Data?) -> Void)
}

/// Service for getting data from web using paths in url or string formats
class NetworkService: NetworkServiceInputProtocol {
	let session: URLSession

	init(session: URLSession) {
		self.session = session
	}


    /// Method for loading images at paths obtained from flickr objects list
    ///
    /// - Parameters:
    ///   - path: obtained from flickr object description element
    ///   - completion: handles retrieved data
	func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void) {
		guard let url = URL(string: path) else {
			completion(nil)
			return
		}
		let dataTask = session.dataTask(with: url) { data, _, _ in
			completion(data)
		}
		dataTask.resume()
	}


    /// Method for loading list of flickr objects at given path
    ///
    /// - Parameters:
    ///   - path: URL of flickr objects, usually constructed in API searchPath method
	func getData(at path: URL, completion: @escaping (Data?) -> Void) {
		let dataTask = session.dataTask(with: path) { data, _, _ in
			completion(data)
		}
		dataTask.resume()
	}
}
