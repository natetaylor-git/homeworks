//
//  PictureProtocols.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol PictureConfiguratorProtocol: class {
    func configure(with viewController: PictureViewController)
}

protocol PicturePresenterOutputProtocol: class {
    func initialLayout()
    func resetLayout()
    func layoutImageView(with image: UIImage?)
    func showError(with errorText: String)
}

protocol PicturePresenterInputProtocol: class {
    func configureView()
    func tappedShowButton()
    func tappedDownloadButton()
    func tappedCleanCacheButton()
}

protocol PictureInteractorInputProtocol: class {
    func downloadImage()
    func getImageFromCache()
    func cleanCache()
}

protocol PictureInteractorOutputProtocol: class {
    func setImage(with imageData: Data)
    func setError(with error: Error)
}
