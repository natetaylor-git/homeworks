//
//  PictureConfigurator.swift
//  hw7
//
//  Created by nate.taylor_macbook on 30/10/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class PictureConfigurator: PictureConfiguratorProtocol {
    func configure(with viewController: PictureViewController) {
        let presenter = PicturePresenter()
        let interactor = PictureInteractor()
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}
