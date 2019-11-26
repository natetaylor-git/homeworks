//
//  FiltersOperations.swift
//  Filter
//
//  Created by nate.taylor_macbook on 24/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol FiltersEffectsDelegate {
    func addFilters(for collectionView: UICollectionView)
}

protocol FiltersEffectsProtocol {
    var collection: [Filter] { get }
    func addFilter(named filterName: String, to image: UIImage) -> UIImage
}

struct Filter {
    var name: String
    var parameters: [String: Any]
    init(name: String, parameters: [String: Any] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}

class FiltersEffects {
    var collection = [Filter]()
    
    init() {
        let originalImage = Filter(name: "Original")
        let noirFilter = Filter(name: "PhotoEffectNoir")
        let comicFilter = Filter(name: "ComicEffect")
        let unsharpFilter = Filter(name: "UnsharpMask",
                                   parameters: ["inputRadius": 2.50,
                                                "inputIntensity": 0.50])
        let circleSplashFilter = Filter(name: "Crystallize",
                                        parameters: ["inputRadius": 10.0,
                                                     "inputCenter": CIVector(x: 150, y: 150)])
        self.collection = [originalImage, comicFilter, noirFilter, unsharpFilter, circleSplashFilter]
    }
    
    func addFilter(named filterName: String, to image: UIImage) -> UIImage {
        let imageToDisplay = self.normalizedImage(of: image)
        
        let context = CIContext(options: nil)
        let ciImage = CIImage(image: imageToDisplay)
        
        guard let currentFilter = CIFilter(name: "CI" + filterName) else {
            print("can't find such filter")
            return image
        }
        
        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        for filter in collection {
            if filter.name == filterName {
                for parameter in filter.parameters {
                    currentFilter.setValue(parameter.value, forKey: parameter.key)
                }
            }
        }
        
        let result: CIImage = currentFilter.value(forKey: kCIOutputImageKey) as! CIImage
        
        let extent = result.extent
        guard let cgImage = context.createCGImage(result, from: extent) else {
            print("createCGImage failed", filterName)
            return image
        }
        let filteredImage = UIImage(cgImage: cgImage)
        
        return filteredImage
    }
    
    private func normalizedImage(of image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImage.Orientation.up) {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("can't get image from ImageContext")
            return image
        }
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

