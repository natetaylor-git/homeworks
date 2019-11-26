//
//  FiltersEffectsProxyPattern.swift
//  Filter
//
//  Created by nate.taylor_macbook on 26/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FiltersEffectsProxy: FiltersEffectsProtocol {
    private let filtersEffects: FiltersEffects
    var collection: [Filter] {
        return self.filtersEffects.collection
    }
    
    init(filtersEffects: FiltersEffects) {
        self.filtersEffects = filtersEffects
    }
    
    func addFilter(named filterName: String, to inputImage: UIImage) -> UIImage {
        let resizedImage = resizeImage(inputImage)
        let filteredImage = self.filtersEffects.addFilter(named: filterName, to: resizedImage)
        return filteredImage
    }
    
    private func resizeImage(_ image: UIImage) -> UIImage {
        let imageSize = image.size
        let targetSize = CGSize(width: imageSize.width / 2, height: imageSize.height / 2)
        
        let scaleX = targetSize.width / imageSize.width
        let scaleY = targetSize.height / imageSize.height
        let newSize = CGSize(width: scaleX * imageSize.width, height: scaleY * imageSize.height)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let result = newImage else {
            print("can't resize image")
            return image
        }
        
        return result
    }
}
