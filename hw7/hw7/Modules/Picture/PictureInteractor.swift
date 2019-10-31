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
    let pictureLoadService: PictureLoadServiceProtocol = PictureLoadService()
    
    func downloadImage() {
        pictureLoadService.downloadImage { imageData, downloadError in
            DispatchQueue.main.async {
                if let error = downloadError {
                    self.presenter.setError(with: error)
                } else {
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
