//
//  FiltersOperations.swift
//  Filter
//
//  Created by nate.taylor_macbook on 24/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol FiltersEffectsProtocol {
    func addFilters(for collectionView: UICollectionView)
}

struct Filter {
    var name: String
    var parameters: [String: Any]
    init(name: String, parameters: [String: Any] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}

class Filters {
    var collection = [Filter]()
    var names = [String: String]()
    //var filterQueue = OperationQueue()
    
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
        
//        filterQueue.maxConcurrentOperationCount = collection.count
    }
    
//    func cancelAllFiltersTasks() {
//        filterQueue.cancelAllOperations()
//    }
//    
//    func addFilterOperation(named filterName: String, to image: UIImage, completion: @escaping (UIImage?) ->()) {
//        filterQueue.addOperation {
//            let outputImage = self.addFilter(named: filterName, to: image)
//            completion(outputImage)
//        }
//    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
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
    
    func addFilter(named filterName: String, to image: UIImage) -> UIImage {
        let resizedImage = resizeImage(image)
        let imageToDisplay = self.normalizedImage(of: resizedImage)
        
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
