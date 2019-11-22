//
//  Interactor.swift
//  UrlSessionLesson
//
//  Created by nate.taylor_macbook on 21/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FlickrInteractor: FlickrInteractorInputProtocol {
	var networkService: NetworkServiceInputProtocol!
    var coreDataService: CoreDataServiceProtocol!
    
    
    /// Loads image at given path using network service and passes image data to completion
	func loadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
		networkService.getData(at: path, parameters: nil) { data in
			guard let data = data else {
				completion(nil)
				return
			}
			completion(UIImage(data: data))
		}
	}

    
    /// Loads image list according to search word using networl service
    /// and passes image model collection to completion
	func loadImageList(by searchString: String, completion: @escaping ([ImageModel]) -> Void) {
		let url = API.searchPath(text: searchString, extras: "url_m")
		networkService.getData(at: url) { data in
			guard let data = data else {
				completion([])
				return
			}
			let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>

			guard let response = responseDictionary,
				let photosDictionary = response["photos"] as? Dictionary<String, Any>,
				let photosArray = photosDictionary["photo"] as? [[String: Any]] else {
					completion([])
					return
			}

			let models = photosArray.map { (object) -> ImageModel in
				let urlString = object["url_m"] as? String ?? ""
				let	title = object["title"] as? String ?? ""
				return ImageModel(path: urlString, description: title)
			}
			completion(models)
		}
	}
    
    func saveImagesToSQLite(from collection: ThreadSafeImageViewCollection) {
        coreDataService.saveImages(from: collection)
    }
    
    /// Loads MOPhoto collection from SQLite and converts it to ImageViewModel collection passing to completion
    func loadImagesFromSQLite(completion: @escaping ([ImageViewModel]) -> Void) {
        coreDataService.loadPhotos { models  in
            let imageViewModels = models.map { (object) -> ImageViewModel in
                let image = UIImage(data: object.data)!
                let imageViewModel = ImageViewModel(description: object.text, image: image)
                return imageViewModel
            }
            completion(imageViewModels)
        }
    }
    
    func deleteAllPhotosFromSQLite(completion: @escaping (Bool) -> Void) {
        coreDataService.deleteAllPhotos(completion: completion)
    }
}
