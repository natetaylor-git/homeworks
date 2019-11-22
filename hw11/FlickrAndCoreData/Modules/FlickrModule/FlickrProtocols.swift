//
//  FlickrProtocols.swift
//  UrlSessionLesson
//
//  Created by nate.taylor_macbook on 21/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol FlickrConfiguratorProtocol: class {
    func configure(with viewController: FlickrViewController)
}

protocol FlickrInteractorInputProtocol {
    func loadImage(at path: String, completion: @escaping (UIImage?) -> Void)
    func loadImageList(by searchString: String, completion: @escaping ([ImageModel]) -> Void)
    func saveImagesToSQLite(from collection: ThreadSafeImageViewCollection)
    func loadImagesFromSQLite(completion: @escaping ([ImageViewModel]) -> Void)
    func deleteAllPhotosFromSQLite(completion: @escaping (Bool) -> Void)
}
