//
//  FiltersCollectionHelper.swift
//  Filter
//
//  Created by nate.taylor_macbook on 24/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol FilterCollectionHelperDelegate: class {
    var buttonsContext: ButtonsContext? { get }
    func setImageView(with image: UIImage?)
}

class FiltersCollectionHelper: NSObject, UICollectionViewDataSource {
    let filters: FiltersEffectsProxy
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
        let filtersEffects = FiltersEffects()
        self.filters = FiltersEffectsProxy(filtersEffects: filtersEffects)
        self.filteredImages = [UIImage?].init(repeating: nil, count: self.filters.collection.count)
        super.init()
    }
    
    func resetFilteredImages() {
        queue.async(flags: .barrier) {
            for index in 0 ..< self.filteredImages.count {
                self.filteredImages[index] = nil
            }
        }
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

extension FiltersCollectionHelper: FiltersEffectsDelegate {
    func addFilters(for collectionView: UICollectionView) {
        guard let currentImage = currentImage else {
            print("no image for filters")
            return
        }
        
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
        }
        filtersGroup.notify(queue: DispatchQueue.main) {
            self.delegate?.buttonsContext?.setupActivity()
        }
    }
}
