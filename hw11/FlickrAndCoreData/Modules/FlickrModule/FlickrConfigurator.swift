//
//  FlickrConfigurator.swift
//  UrlSessionLesson
//
//  Created by nate.taylor_macbook on 21/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class FlickrConfigurator: FlickrConfiguratorProtocol {
    func configure(with viewController: FlickrViewController) {
        let networkService = NetworkService(session: SessionFactory().createDefaultSession())
        let interactor = FlickrInteractor()
        let coreDataService = CoreDataService()
        
        interactor.networkService = networkService
        interactor.coreDataService = coreDataService
        viewController.interactor = interactor
    }
}
