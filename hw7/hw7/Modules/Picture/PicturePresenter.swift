//
//  PicturePresenter.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class PicturePresenter: PicturePresenterInputProtocol, PictureInteractorOutputProtocol {
    
    var interactor: PictureInteractorInputProtocol!
    weak var view: PicturePresenterOutputProtocol!
    
    func tappedShowButton() {
        interactor.getImageFromCache()
    }
    
    func tappedDownloadButton() {
        interactor.downloadImage()
    }
    
    func tappedCleanCacheButton() {
        interactor.cleanCache()
    }
    
    func setImage(with imageData: Data) {
        let imageToShow = UIImage(data: imageData)
        
        if let image = imageToShow {
            //here u can do any operations with image
            view.layoutImageView(with: image)
        } else {
            view.showError(with: "can't convert downloaded data to image")
        }
    }
    
    func configureView() {
        view.initialLayout()
    }

    func setError(with error: Error) {
        let errorDescription = error.localizedDescription
        view.resetLayout()
        view.showError(with: errorDescription)
    }
}
