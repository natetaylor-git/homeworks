//
//  CustomCollectionViewLayout.swift
//  hw8
//
//  Created by nate.taylor_macbook on 07/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    let cellHeight: CGFloat = 120.0
    let cellWidth: CGFloat = 200.0
    let paddingY: CGFloat = 20.0
    let paddingX: CGFloat = 40.0
    let topPadding: CGFloat = 0.0 //10.0
    let leftPadding: CGFloat = 20.0
    let rightPadding: CGFloat = 20.0
    
    var cellAttributesDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    
    var update = true
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if !update {
            let yOffset = collectionView.contentOffset.y
            
            for section in 0..<collectionView.numberOfSections {
                let cellIndex = IndexPath(item: 0, section: section)
                
                if let attributes = cellAttributesDictionary[cellIndex] {
                    var frame = attributes.frame
                    frame.origin.y = yOffset + topPadding //+ cellHeight / 4
                    attributes.frame = frame
                }
            }
            return
        }
        
        update = false
        
        var maxNumberOfItemsInSection = 0
        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            if numberOfItems > maxNumberOfItemsInSection {
                maxNumberOfItemsInSection = numberOfItems
            }
            
            for item in 0..<numberOfItems {
                let cellIndex = IndexPath(item: item, section: section)
                var xPos: CGFloat
                var yPos: CGFloat
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                if item == 0 {
                    xPos = CGFloat(section) * (cellWidth + paddingX) + leftPadding
                    yPos = topPadding //cellHeight / 4 + topPadding
                    cellAttributes.frame = CGRect(origin: CGPoint(x: xPos, y: yPos),
                                                  size: CGSize(width: cellWidth, height: cellHeight * 3/4))
                     cellAttributes.zIndex = 2
                } else {
                    xPos = CGFloat(section) * (cellWidth + paddingX) + leftPadding
                    yPos = CGFloat(item) * (cellHeight + paddingY) + topPadding
                    cellAttributes.frame = CGRect(origin: CGPoint(x: xPos, y: yPos),
                                                  size: CGSize(width: cellWidth, height: cellHeight))
                     cellAttributes.zIndex = 1
                }
                
                self.cellAttributesDictionary[cellIndex] = cellAttributes
            }
        }
        
        let contentWidth = leftPadding + CGFloat(collectionView.numberOfSections) * (cellWidth + paddingX) - paddingX + rightPadding
        let contentHeight = topPadding + CGFloat(maxNumberOfItemsInSection) * (cellHeight + paddingY)
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDictionary[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for attributes in cellAttributesDictionary.values {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
