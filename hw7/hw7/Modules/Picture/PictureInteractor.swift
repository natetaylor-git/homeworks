//
//  PictureIntegrator.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class PictureInteractor: PictureInteractorInputProtocol {
    weak var presenter: PictureInteractorOutputProtocol!
    let pictureLoadService = PictureLoadService()
    
    func downloadImage() {
        pictureLoadService.downloadImage { imageData, response, downloadError in
            DispatchQueue.main.async {
                if let error = downloadError {
                    self.presenter.setError(with: error)
                } else {
                    guard let retrievedImageData = imageData else {
                        print("[Info] No Data")
                        return
                    }
                    self.pictureLoadService.saveToCache(data: retrievedImageData, response: response)
                    print("[Info] Data was successfully cached")
                }
            }
        }
    }
    
    internal func getImageFromCache() {
        pictureLoadService.downloadImageFromCache { imageData, cacheError in
            DispatchQueue.main.async {
                if let error = cacheError {
                    self.presenter.setError(with: error)
                } else {
                    self.presenter.setImage(with: imageData!)
                }
            }
        }
    }
    
    func cleanCache() {
        pictureLoadService.cleanCache()
    }
}
