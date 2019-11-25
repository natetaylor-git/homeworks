//
//  FiltersCollectionHelper.swift
//  Filter
//
//  Created by nate.taylor_macbook on 24/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol FilterCollectionHelperDelegate: class {
    func setImageView(with image: UIImage?)
    func activateButtons()
}

class FiltersCollectionHelper: NSObject, UICollectionViewDataSource {
    let filters = Filters()
    var filteredImages = [UIImage?]()
    var currentImage: UIImage? {
        willSet {
            filteredImages[0] = newValue
        }
    }
    
    var newImageLoaded = false
    weak var delegate: FilterCollectionHelperDelegate?
    private let queue = DispatchQueue(label: "com.filters.queue", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
    
    override init() {
        super.init()
        self.filteredImages = [UIImage?].init(repeating: nil, count: self.filters.collection.count)
    }
    
    func resetFilteredImages() {
        queue.async(flags: .barrier) {
            for index in 0 ..< self.filteredImages.count {
                self.filteredImages[index] = nil
            }
        }
//        self.filters.cancelAllFiltersTasks()
//        self.filteredImages = [UIImage?].init(repeating: nil, count: self.filters.collection.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellReuseId", for: indexPath) as! FilteredImageCell
        cell.filterNameLabel.text = filters.collection[indexPath.row].name
        
        if let newImage = filteredImages[indexPath.row] {
            cell.indicator.stopAnimating()
            cell.imageView.image = newImage
            return cell
        }
        
        if newImageLoaded {
            cell.indicator.startAnimating()
        }

        return cell
    }
}

extension FiltersCollectionHelper: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FilteredImageCell
        guard let image = cell.imageView.image else {
            return
        }
        delegate?.setImageView(with: image)
    }
}

extension FiltersCollectionHelper: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let itemSize = collectionView.frame.height - padding * 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension FiltersCollectionHelper: FiltersEffectsProtocol {
    func addFilters(for collectionView: UICollectionView) {
        guard let currentImage = currentImage else {
            print("no image for filters")
            return
        }
        
//        for (index, filter) in filters.collection.enumerated() {
//            self.filters.addFilterOperation(named: filter.name, to: currentImage) {
//                (filteredImage) in
//                self.filteredImages[index] = filteredImage
//                DispatchQueue.main.async {
//                    collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
//                }
//            }
//        }
        let filtersGroup = DispatchGroup()
        for (index, filter) in filters.collection.enumerated() {
            if index == 0 {
                continue
            }
            filtersGroup.enter()
            queue.async() {
                let filteredImage =  self.filters.addFilter(named: filter.name, to: currentImage)
                self.filteredImages[index] = filteredImage
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    filtersGroup.leave()
                }
            }
            
            filtersGroup.notify(queue: DispatchQueue.main) {
                self.delegate?.activateButtons()
            }
        }

//        guard let currentImage = currentImageView?.image else {
//            return
//        }
//        self.filteredImages = [filters.addPhotoEffectNoir(for: currentImage),
//                               filters.addComicEffect(for: currentImage),
//                               filters.addGlassDistortionEffect(for: currentImage),
//                               filters.addUnSharpEffect(for: currentImage)]
    }
}
