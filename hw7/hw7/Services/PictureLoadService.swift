//
//  PictureLoadService.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol PictureLoadServiceProtocol: class {
    var urlSource: String { get set }
    func downloadImage(completion: @escaping (Data?, URLResponse?, CustomError?) -> Void)
    func downloadImageFromCache(completion: @escaping (Data?, CustomError?) -> Void)
    func saveToCache(data: Data, response: URLResponse?)
    func cleanCache()
}

enum CustomError : Error {
    case noUrl
    case noData(_ urlSource: String)
    case sessionError(_ error: Error)
    case emptyCache
}

extension CustomError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noUrl: return "no URL"
        case .noData(let urlSource): return "no data retrieved: " + urlSource
        case .sessionError(let error): return error.localizedDescription
        case .emptyCache: return "no image in cache"
        }
    }
}

class PictureLoadService: PictureLoadServiceProtocol {
    var urlSource: String = "http://icons.iconarchive.com/icons/dtafalonso/ios8/512/Calendar-icon.png"
    
    private let session: URLSession
    private let cache: URLCache
    
    init(session: URLSession = URLSession.shared, cache: URLCache = URLCache.shared) {
        self.session = session
        self.cache = cache
    }
    
    func downloadImage(completion: @escaping (Data?, URLResponse?, CustomError?) -> Void) {
        guard let url = URL(string: self.urlSource) else {
            completion(nil, nil, CustomError.noUrl)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let currentError = error {
                let sessionError = CustomError.sessionError(currentError)
                completion(nil, nil, sessionError)
                return
            }
            
            guard let currentData = data else {
                let dataError = CustomError.noData(self.urlSource)
                completion(nil, nil, dataError)
                return
            }
            
            let imageData = currentData
            completion(imageData, response, nil)
        }
        
        task.resume()
    }
    
    func saveToCache(data: Data, response: URLResponse?) {
        guard let response = response else { return }
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    func downloadImageFromCache(completion: @escaping (Data?, CustomError?) -> Void) {
        guard let url = URL(string: self.urlSource) else {
            return completion(nil, CustomError.noUrl)
        }
        
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request) {
            let data = cachedResponse.data
            return completion(data, nil)
        } else {
            return completion(nil, CustomError.emptyCache)
        }
    }
    
    func cleanCache() {
        URLCache.shared.removeAllCachedResponses()
    }
}
