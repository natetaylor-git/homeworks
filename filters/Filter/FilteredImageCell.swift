//
//  FilteredImageCell.swift
//  Filter
//
//  Created by nate.taylor_macbook on 24/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FilteredImageCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    var filterNameLabel: UILabel = {
        let filterNameLabel = UILabel()
        filterNameLabel.backgroundColor = .white
        filterNameLabel.textColor = .black
        filterNameLabel.textAlignment = .center
        return filterNameLabel
    }()
    
    var indicator = UIActivityIndicatorView()
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.filterNameLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let padding: CGFloat = 5
        let viewOrigin = self.bounds.origin
        let imageViewSide = self.bounds.height * 3/4
        let filterNameLabelHeight = self.bounds.height - padding - imageViewSide
        
        self.imageView.frame = CGRect(origin: CGPoint(x: viewOrigin.x + (self.bounds.width - imageViewSide) / 2,
                                                      y: viewOrigin.y),
                                      size: CGSize(width: imageViewSide, height: imageViewSide))
        self.imageView.backgroundColor = .white
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(self.imageView)
        
        self.filterNameLabel.frame = CGRect(origin: CGPoint(x: viewOrigin.x,
                                                            y: viewOrigin.y + imageViewSide + padding),
                                            size: CGSize(width: self.bounds.width, height: filterNameLabelHeight))
        self.filterNameLabel.backgroundColor = .clear
        self.contentView.addSubview(self.filterNameLabel)
        
        let indicatorSide: CGFloat = 40
        indicator.frame = CGRect(origin: CGPoint(x: (imageViewSide - indicatorSide) / 2,
                                                 y: (imageViewSide - indicatorSide) / 2),
                                 size: CGSize(width: indicatorSide, height: indicatorSide))
        indicator.hidesWhenStopped = true
        indicator.color = .black
        self.imageView.addSubview(self.indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
