//
//  ImageModel.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

/// Image model for object from Flickr that consist of "url_m" and "title" elements
struct ImageModel {
	let path: String
	let description: String
}

/// Image view model for view representation of image model object
struct ImageViewModel {
    let description: String
    let image: UIImage
}
