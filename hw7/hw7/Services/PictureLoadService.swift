//
//  PictureLoadService.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol PictureLoadServiceProtocol: class {
    var urlSource: String { get }
    func downloadImage(completion: @escaping (Data?, Error?) -> Void)
    func downloadImageFromCache(completion: @escaping (Data?, Error?) -> Void)
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
    var urlSource: String {
        get {
            return "http://icons.iconarchive.com/icons/dtafalonso/ios8/512/Calendar-icon.png"
        }
    }
    
    func downloadImage(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: self.urlSource) else {
            completion(nil, CustomError.noUrl)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let currentError = error {
                completion(nil, CustomError.sessionError(currentError))
                return
            }
            
            guard let currentData = data else {
                completion(nil, CustomError.noData(self.urlSource))
                return
            }
            
            let imageData = currentData
            self.saveToCache(data: imageData, response: response!)
            completion(imageData, nil)
        }
        
        task.resume()
    }
    
    private func saveToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    func downloadImageFromCache(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: self.urlSource) else {
            return completion(nil, CustomError.noUrl)
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return completion(cachedResponse.data, nil)
        } else {
            return completion(nil, CustomError.emptyCache)
        }
    }
    
    func cleanCache() {
        URLCache.shared.removeAllCachedResponses()
    }
}
